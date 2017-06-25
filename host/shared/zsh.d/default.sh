
#------
# Path
#------

pathmunge $($PYTHON -m site --user-base)/bin
pathmunge $BIN

pathmunge /usr/local/bin after
pathmunge /usr/bin after
pathmunge /bin after

pathmunge /usr/sbin after
pathmunge /sbin after

#-------------
# Development
#-------------

export PYTHON_USER_SITE=$($PYTHON -m site --user-site)
