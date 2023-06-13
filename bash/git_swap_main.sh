!/bin/bash

display_usage() {
    echo "Usage: $0 -u <repository_url> -n <new_branch_name> -o <old_branch_name>"
    echo "Options:"
    echo "  -u, --url             Repository URL"
    echo "  -n, --new_branch_name New branch name"
    echo "  -o, --old_branch_name Old branch name"
    echo "  -h, --help            Display this help message"
}

while getopts u:n:o:h option
do
    case "${option}" in
        u) REPO_URL=${OPTARG};;
        n) NEW_BRANCH_NAME=${OPTARG};;
        o) OLD_BRANCH_NAME=${OPTARG};;
        h) display_usage
           exit 0;;
        *) display_usage
           exit 1;;
    esac
done

if [[ -z $REPO_URL || -z $NEW_BRANCH_NAME || -z $OLD_BRANCH_NAME ]]; then
    display_usage
    exit 1
fi

git clone $REPO_URL
cd "$(basename "$REPO_URL" .git)"
git checkout $NEW_BRANCH_NAME
git checkout $OLD_BRANCH_NAME -- .
git commit -m "Migrate files from old main branch"
git push origin $NEW_BRANCH_NAME
git branch -m $NEW_BRANCH_NAME main
git branch -m $OLD_BRANCH_NAME desired_name
git push origin --delete $OLD_BRANCH_NAME
git push origin main
