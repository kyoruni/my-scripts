#!/usr/bin/env bash

function usage {
  cat <<EOF
${0} creates shebang written file.

Usage:
    ${0} <filename>.sh
EOF
}

while getopts "h-:" opt; do
  if [ $opt = "-" ]; then
  opt=$OPTARG
  fi

  case "$opt" in
    h | help)
      usage
      exit 0
      ;;
    ?)
      exit 1
      ;;
    *)
      echo "${0}: illegal option --$opt"
      exit 1
      ;;
    esac
done

# 引数がなかったら、ファイル名を入力させる
if [ $# -eq 0 ]; then
  read -p "Please input file name: " file_name
else
  file_name=$1
fi

# shファイル以外は指定不可
if [[ ! "$file_name" =~ ^.+\.sh$ ]]; then
  echo "Please select .sh file"
  exit 0
fi

# 存在するファイルであれば、処理を行わない
if [ -e $file_name ]; then
  echo "${file_name} exists"
  exit 0
fi

# 指定されたファイルを作成
touch $file_name
cat << EOF >> $file_name
#!/usr/bin/env bash

exit 0
EOF

echo "created a $file_name"
exit 0