################################################################################
#
# dinit
#
################################################################################
DINIT_VERSION = 0.19.4
DINIT_SOURCE = dinit-$(DINIT_VERSION).tar.xz
DINIT_SITE = https://github.com/davmac314/dinit/releases/download/v$(DINIT_VERSION)
DINIT_LICENSE = Apache-2.0
DINIT_LICENSE_FILES = LICENSE

DINIT_CFLAGS = $(TARGET_CFLAGS) -std=c++17 -fno-rtti -fno-plt -flto
DINIT_LDFLAGS = $(TARGET_LDFLAGS) -flto -Os

define DINIT_BUILD_CMDS
	@echo "SBINDIR=/sbin" > $(@D)/mconfig
	@echo "MANDIR=/usr/share/man" >> $(@D)/mconfig
	@echo "SYSCONTROLSOCKET=/run/dinitctl" >> $(@D)/mconfig
	@echo "BUILD_SHUTDOWN=yes" >> $(@D)/mconfig
	@echo "SANITIZEOPTS=-fsanitize=address,undefined" >> $(@D)/mconfig
	@echo "CXX=$(CXX)" >> $(@D)/mconfig
	@echo "CXX_FOR_BUILD=$(TARGET_CXX)" >> $(@D)/mconfig
	@echo "CXXFLAGS_FOR_BUILD=$(DINIT_CFLAGS)" >> $(@D)/mconfig
	@echo "CPPFLAGS_FOR_BUILD=$(DINIT_CFLAGS)" >> $(@D)/mconfig
	@echo "LD=$(TARGET_LD)" >> $(@D)/mconfig
	@echo "LDFLAGS_FOR_BUILD=$(DINIT_LDFLAGS)" >> $(@D)/mconfig
	@echo "STRIPOPTS=-s --strip-program=$(TARGET_STRIP)" >> $(@D)/mconfig
	@echo "DEFAULT_AUTO_RESTART=ALWAYS" >> $(@D)/mconfig
	@echo "DEFAULT_START_TIMEOUT=60" >> $(@D)/mconfig
	@echo "DEFAULT_STOP_TIMEOUT=10" >> $(@D)/mconfig
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define DINIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src install DESTDIR=$(TARGET_DIR)
        cd $(TARGET_DIR)/sbin; ln -fs dinit init
	mkdir -p $(TARGET_DIR)/etc/dinit.d
	touch $(TARGET_DIR)/etc/inittab
	$(CONFIG_INSTALL)
endef

$(eval $(generic-package))
