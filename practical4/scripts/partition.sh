#! /bin/bash

command=$1

infile="lupos.hashes"
outdir="hashes"
potfile="practical4.potfile"

des="$outdir/DES.hashes"
md5crypt="$outdir/MD5Crypt.hashes"
sha256="$outdir/SHA256.hashes"
sha512="$outdir/SHA512.hashes"
pbkdf2="$outdir/pbkdf2.hashes"
argon="$outdir/argon.hashes"

# des_reg='^[a-zA-Z0-9\.\/]{13}$'
des_reg='^[^\$]+'
md5_reg='^\$1\$'
sha256_reg='^\$5\$'
sha512_reg='^\$6\$'
pbkdf2_reg='\$pbkdf2-sha256'
argon_reg='^\$argon2i\$'


total_hashes=$(wc -l < $infile)
echo "Total number of hashes in $infile: " $total_hashes

function awkIt() {
  awk -v reg=$1 '$0~reg' $2
}

function partition() {
  # Grab DES -m -1500
  awkIt $des_reg $infile > $des
  des_no_hashes=$(wc -l < $des)

  # Grab MD5crypt -m 500
  awkIt $md5_reg $infile > $md5crypt
  md5crypt_no_hashes=$(wc -l < $md5crypt)

  # Grab SHA 256 crypt -m 7400 
  awkIt $sha256_reg  $infile > $sha256
  sha256_no_hashes=$(wc -l < $sha256)

  # Grab SHA 512 crypt -m 1800
  awkIt $sha512_reg $infile > $sha512
  sha512_no_hashes=$(wc -l < $sha512)

  # Grab pbkdf2SHA
  awkIt $pbkdf2_reg $infile > $pbkdf2
  pbkdf2_no_hashes=$(wc -l < $pbkdf2)

  # Grab Argon
  awkIt $argon_reg $infile > $argon
  argon_no_hashes=$(wc -l < $argon)

  printf "DES: %s hashes \n" $des_no_hashes
  printf "SHA256: %s hashes \n" $sha256_no_hashes
  printf "SHA512: %s hashes \n" $sha512_no_hashes
  printf "MD5: %s hashes \n" $md5crypt_no_hashes
  printf "pbkdf2SHA: %s hashes \n" $pbkdf2_no_hashes
  printf "argon: %s hashes \n" $argon_no_hashes

  ((total_parsed_hashes=$des_no_hashes + $sha256_no_hashes + $sha512_no_hashes + md5crypt_no_hashes + pbkdf2_no_hashes + argon_no_hashes))
  printf "Total parsed hashes: %s\n" $total_parsed_hashes
}

function getProgress() {
  printf "$1: %s / %s \n" $(awkIt $2 $potfile | wc -l) $(awkIt $2 $infile | wc -l)
}

if [ "$command" == "partition" ]; then
  partition
elif [ "$command" == "progress" ]; then
  getProgress DES $des_reg
  getProgress MD5 $md5_reg
  getProgress SHA256 $sha256_reg
  getProgress SHA512 $sha512_reg
  getProgress pbkdf2 $pbkdf2_reg
  getProgress argon $argon_reg
else
  echo "No command given"
fi