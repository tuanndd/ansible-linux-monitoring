#!/bin/bash

# References:
# - https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309
# - https://bytefreaks.net/gnulinux/bash/cecho-a-function-to-print-using-different-colors-in-bash#google_vignette

# The following function prints a text using custom color
# -c or --color define the color for the print. See the array colors for the available options.
# -n or --noline directs the system not to print a new line after the content.
# Last argument is the message to be printed.
cecho () {

	declare -A colors;
	colors=(\
		['black']='\E[0;47m'\
		['red']='\E[0;31m'\
		['green']='\E[0;32m'\
		['yellow']='\E[0;33m'\
		['blue']='\E[0;34m'\
		['magenta']='\E[0;35m'\
		['cyan']='\E[0;36m'\
		['white']='\E[0;37m'\
	);

	local defaultMSG="No message passed.";
	local defaultColor="black";
	local defaultNewLine=true;

	while [[ $# -gt 1 ]];
	do
	key="$1";

	case $key in
		-c|--color)
			color="$2";
			shift;
		;;
		-n|--noline)
			newLine=false;
		;;
		*)
			# unknown option
		;;
	esac
	shift;
	done

	message=${1:-$defaultMSG};   # Defaults to default message.
	color=${color:-$defaultColor};   # Defaults to default color, if not specified.
	newLine=${newLine:-$defaultNewLine};

	echo -en "${colors[$color]}";
	echo -en "$message";
	if [ "$newLine" = true ] ; then
		echo;
	fi
	tput sgr0; #  Reset text attributes to normal without clearing screen.

	return;
}

heading () {

	cecho -c 'yellow' "$@";
}

error () {

	cecho -c 'red' "$@";
}

info () {

	cecho -c 'green' "$@";
}


# constants
ROOTCA_KEY=rootCA.key
ROOTCA_CRT=rootCA.crt

LOCAL_COM_KEY=local.com.key
LOCAL_COM_CRT=local.com.crt
LOCAL_COM_CSR=local.com.csr


# main()
cd certs

heading "Step 1: Create Root CA (Done once)"
if [ ! -f "$ROOTCA_KEY" ]; then
    info "Creat root key"
    openssl genrsa -out $ROOTCA_KEY 4096

    info "Create and self sign the Root Certificate"
    openssl req -x509 -new -nodes -key $ROOTCA_KEY -sha256 -days 1024 -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=*.com" -out $ROOTCA_CRT
else
    error "Error: $ROOTCA_KEY exists."
fi

heading "Step 2: Create local.com certificate"
if [ ! -f "$LOCAL_COM_KEY" ]; then
    info "Create the certificate key"
    openssl genrsa -out $LOCAL_COM_KEY 2048

    info "Create the signing (csr)"
    openssl req -new -sha256 -key $LOCAL_COM_KEY -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=*.local.com" -out $LOCAL_COM_CSR

    info "Generate the certificate using the local.com csr and key along with the CA Root key"
    openssl x509 -req -in $LOCAL_COM_CSR -CA $ROOTCA_CRT -CAkey $ROOTCA_KEY -CAcreateserial -out $LOCAL_COM_CRT -days 500 -sha256
else
    error "Error: $LOCAL_COM_KEY exists."
fi