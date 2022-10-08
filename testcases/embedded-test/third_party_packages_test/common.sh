function downloadFromGitee() {
    downloadName=$1
    downloadBranch=$2
    if [ -z $downloadBranch ]; then
        downloadBranch="openEuler-22.03-LTS"
    fi
    giteeName="src-openeuler"
    if [[ "$3"x != ""x ]]; then  
        giteeName=$3
    fi

    git clone -b $downloadBranch https://gitee.com/$giteeName/$downloadName.git --depth=1 -v tmp_download/$1
}

function downloadSource() {
    downloadUrl=$1
    downloadBranch=$2
    urlName=$(basename ${downloadUrl##*/} .git)

    git clone -b $downloadBranch $downloadUrl --depth=1 -v tmp_download/${urlName}
}

function extractPackage() {
    downloadName=$1
    packageName=$2
    extractType=$3
    pushd tmp_download
    if [[ -z $packageName ]]; then
        packageName=$(find ./ -name "*$downloadName*.tar.*")
    fi
    if [[ -z $packageName ]]; then
        packageName=$(find ./ -name "*$downloadName*.zip")
    fi
    if [[ -z $extractType ]]; then
        if [[ $(echo $packageName | grep ".tar.") ]]; then
            extractType="tar"
        elif [[ $(echo $packageNamegrep | ".zip" $packageName) ]]; then
            extractType="zip"
        fi
    fi
    if [[ $extractType == "zip" ]]; then
        unzip -d ../tmp_extract $packageName
    elif [[ $extractType == "tar" ]]; then
        mkdir -p ../tmp_extract
        tar -xf $packageName -C ../tmp_extract
    fi
    popd
}

function copyFiles() {
    findDir="./tmp_extract/$1"
    if [[ "$3"x != ""x ]]; then
        findDir=$3
    fi

    findThings=$(find ${findDir} -name $2)
    if [ -f $findThings ]; then
        cp $findThings ./tmp_test/
    elif [ -d $findThings ]; then
        cp -rR $findThings ./tmp_test/
    else
        for oneThing in ${findThings}; do
            cp -rR $oneThing ./tmp_test/
        done
    fi
}

main() {
    mkdir -p ./tmp_download
    mkdir -p ./tmp_extract
    mkdir -p ./tmp_test
    for opt in "$@"; do
        if [[ $opt == "-d" ]]; then
            downloadFromGitee $2 $3 $6
            if [ -z $6 ]; then
                extractPackage $2 $4 $5
            fi
            return 0
        elif [[ $opt == "-r" ]]; then
            rm -rf ./tmp_download
            rm -rf ./tmp_extract
            tar -cf tmp_test.tar ./tmp_test
            rm -rf ./tmp_test
            if [[ $2 == "all" ]]; then
                rm -rf ./tmp_test.tar
                rm -rf ./dejagnu
            fi
            return 0
        elif [[ $opt == "-c" ]]; then
            copyFiles $2 $3 $4
            return 0
        elif [[ $opt == "-s" ]]; then
            downloadSource $2 $3
            return 0
        else
            return 1
        fi
    done
    
}

main $@