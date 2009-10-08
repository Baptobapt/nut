dnl Check for LIBNEON compiler flags. On success, set nut_have_neon="yes"
dnl and set LIBNEON_CFLAGS and LIBNEON_LDFLAGS. On failure, set
dnl nut_have_neon="no". This macro can be run multiple times, but will
dnl do the checking only once.

AC_DEFUN([NUT_CHECK_LIBNEON],
[
if test -z "${nut_have_neon_seen}"; then
   nut_have_neon_seen=yes

   dnl save CFLAGS and LDFLAGS
   CFLAGS_ORIG="${CFLAGS}"
   LDFLAGS_ORIG="${LDFLAGS}"

   dnl See which version of the neon library (if any) is installed
   AC_MSG_CHECKING(for libneon version via pkg-config (0.25.0 minimum required))
   NEON_VERSION=`pkg-config --silence-errors --modversion neon`
   NEON_MIN_VERSION=`pkg-config --silence-errors --atleast-version=0.25.0 neon`
   if (test "$?" != "0")
   then
      AC_MSG_RESULT(${NEON_VERSION} found)
      nut_have_neon=no
   else
      AC_MSG_RESULT(${NEON_VERSION} found)
      AC_DEFINE_UNQUOTED(LIBNEON_VERSION, "${NEON_VERSION}", [Define version of the neon library])
      nut_have_neon=yes
   fi

   dnl Check for neon libs and flags
   AC_MSG_CHECKING(for libneon cflags via pkg-config)
   CFLAGS=`pkg-config --silence-errors --cflags neon`
   if (test "$?" != "0")
   then
      AC_MSG_RESULT(not found)
      nut_have_neon=no
   else
      AC_MSG_RESULT(${CFLAGS})
   fi

   AC_MSG_CHECKING(for libneon ldflags via pkg-config)
   LDFLAGS=`pkg-config --silence-errors --libs neon`
   if (test "$?" != "0")
   then
      AC_MSG_RESULT(not found)
      nut_have_neon=no
   else
      AC_MSG_RESULT(${LDFLAGS})
   fi

   dnl Check for timeouts in library
   AC_CHECK_FUNCS(ne_set_connect_timeout)
   
   if test "${nut_have_neon}" = "yes"; then
      LIBNEON_CFLAGS="${CFLAGS}"
      LIBNEON_LDFLAGS="${LDFLAGS}"
   fi

   dnl restore original CFLAGS and LDFLAGS
   CFLAGS="${CFLAGS_ORIG}"
   LDFLAGS="${LDFLAGS_ORIG}"

fi
])
