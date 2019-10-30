# Git

## add alias for unstaging
    git config --global alias.unstage "reset HEAD"

## default git prune
    git config --global fetch.prune true

for default on pull:
    git config --global pull.rebase true

## show database statistics
    git count-objects -v

## compress database
    git repack

## verify files in git
    git fsck --full

## diff HEAD to previous HEAD
    git diff HEAD HEAD^
or:
    git diff HEAD HEAD~1

## .gitignore
    /absolute/path
    relative/path
    *.todo
    !exception for this.todo

## replace all local files by HEAD
    git reset --hard HEAD

## replace only one file by HEAD
    git checkout HEAD foo.txt

## change last commit
    git commit --amend

## show ALL git commits and revert to deleted commit
    git reflog
    git reset --hard e6b0203

## create branch
    git branch <NAME>

## switch branch
    git checkout <NAME>

## create and switch
    git checkout -b <NAME>

## merge
    git merge <branch>

## conflict
    git checkout --theirs <file>
    git checkout --ours <file>

## create git bare repository
    git clone --bare <myfiles> newrepo.git

## rebase
    git rebase <branch>

## interactive rebase
    git rebase -i <branch>

## apply single commit to branch
    git cherry-pick <REF>

## git show refs (e.g. bitbake recipes)
    git show-ref

## push tags
    git push --tags

## delete local tag / branch
    git tag -d <name>
    git branch -d <branch>

## delete remote tag / branch
    git push origin :refs/tags/v1.0
    git push origin :refs/heads/testing

## stash (+ untracked files)
    git stash -u
    git stash pop
    git stash list
    git stash pop stash@{1}
