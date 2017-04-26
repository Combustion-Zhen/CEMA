# Zhen Lu 2015/01/29
# Pattern rule

%.o: %.f90
	$(FC) $(FCFLAGS) $(INCFLAGS) -c $<

%.o: %.f
	$(FC) $(FCFLAGS) $(INCFLAGS) -c $<

$(LIB_NAME).so: $(OBJS)
	$(FC) -shared -o $@ $(OBJS) $(LDFLAGS)

$(LIB_NAME).a: $(OBJS)
	$(AR) $(LIBDIR)/$(LIB_NAME).a $(OBJS)

$(APP_NAME): $(OBJS)
	$(FC) -o $(BINDIR)/$@ $(OBJS) $(LINK_LIBS) $(LDFLAGS) $(LINK_SYS_LIBS)
ifneq ($(BUILD_TYPE), debug)
	strip $(BINDIR)/$(APP_NAME)
endif

debug: clean
	make BUILD_TYPE=debug

clean::
	$(RM) $(CREATE_LIBS) $(NAME) $(OBJS) *.mod
