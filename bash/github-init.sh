#!/usr/bin/env bash
set -eu

usage () {
  echo "${0} create repository on github."
}

while getopts "h-:" opt; do
  if [ "$opt" = "-" ]; then
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

# リポジトリ名
read -p "Please input repository name: " repo_name
if [ -z "$repo_name" ]; then
  echo "Please input repository name."
  exit 0
fi

# 説明文
read -p "Prease input repository description: " repo_description
if [ -z "$repo_description" ]; then
  echo "Please input repository description."
  exit 0
fi

# 可視性
read -p "Prease input repository visibility (public or private) : " repo_visibility
if [ -z "$repo_visibility" ]; then
  echo "Please input repository visibility."
  exit 0
fi
if [ ! "$repo_visibility" = "public" ] && [ ! "$repo_visibility" = "private" ]; then
  echo "repository visibility is only public or private."
  exit 0
fi

repo_url="https://github.com/kyoruni/${repo_name}"
git init

# 自分用エイリアス(nameとemailを設定)
git kyoruniname
git kyoruniemail

git add .
git commit -m ":tada: first commit"
git branch -M main

# repo_descriptionに--publicとか入れて、descriptionにスペースを含む文字列が来るとうまくいかなかった
if [ "$repo_visibility" = 'public' ]; then
  gh repo create "$repo_name" --description "${repo_description}" --public
else
  gh repo create "$repo_name" --description "${repo_description}" --private
fi

git remote add origin "${repo_url}".git
git push -u origin main

echo "Create repository: ${repo_url}"
exit 0