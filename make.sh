#!/bin/bash


function load_example_components () {
TABLE="logo1.png https://pub-714f8d634e8f451d9f2fe91a4debfa23.r2.dev/keep/T204-meta/geologo.white.shadow.png--630819accdece28219343e4b281e9455.png
logo2.png https://pub-714f8d634e8f451d9f2fe91a4debfa23.r2.dev/keep/T204-meta/geologo.white.hardshadow.png--f8e2c8d59a1c0c2feff3c62a7bd5cef3.png
bg.png https://pub-714f8d634e8f451d9f2fe91a4debfa23.r2.dev/keep/steam-assets-texkit/bg.png--09a71c939ae7590874e48754e820cf51.png"
    while read -r line; do
        fn="$(cut -d' ' -f1 <<< "$line")"
        url="$(cut -d' ' -f2 <<< "$line")"
        if [[ ! -e "components/$fn" ]]; then
            wget "$url" -O "components/$fn"
        else
            echo "File components/$fn already exists!"
        fi
    done <<< "$TABLE"
}




case $1 in
    steam | steam/)
        for i in steam/*.tex; do
            bash "$0" "$i"
        done
        realpath output-steam/*.png
        ;;
    *.tex)
        xelatex -output-directory="$(dirname "$1")" "$1"
        echo "PDF output path: $(realpath "$(sed 's|.tex$|.pdf|' <<< "$1")")"
        if grep -qs '^steam/' <<< "$1"; then
            mkdir -p output-steam
            outfn="output-steam/$(basename "$1" | sed 's|.tex$||g')"
            pdftoppm -singlefile -png -r 72 "$(sed 's|.tex$|.pdf|g' <<< "$1")" "$outfn"
            # "$(sed 's|.tex$||g' <<< "$outfn")"
        fi
        ;;
    */*.)
        [[ -e "$1"tex ]] && bash "$0" "$1"tex
        ;;
    '')
        for i in steam/*.tex; do
            echo bash "$0" "$i"
        done
        ;;
    oss)
        cfoss meta/SteamAssetsTexKitManual.pdf
        minoss meta/SteamAssetsTexKitManual.pdf
        ;;
    components)
        mkdir -p components
        load_example_components
        ;;
esac

