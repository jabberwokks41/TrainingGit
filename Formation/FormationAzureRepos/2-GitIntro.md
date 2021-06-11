# steps:

1) create a file locally
2) initialize an empty git repository
3) add the files that need to be commit (staged Area)
4) commit the files locally
5) Push changes to Azure Repos

# install Git

git-scm.com/download/win

open cmd or git cmd :

```console
C:\Users\jbarbaro>git --version
git version 2.28.0.windows.1
```

# identity git

## all config

```console
git config --list --show-origin
```

## add user/mail 

```console
git config --global user.name "julien barbaro"
git config --global user.email jbarbaro@groupeisagri.com
```

# locally

```console
C:\FormationAzureDevOps\AzureRepos\files

C:\FormationAzureDevOps\AzureRepos\files>git init
Initialized empty Git repository in C:/FormationAzureDevOps/AzureRepos/files/.git/

C:\FormationAzureDevOps\AzureRepos\files>git add .

C:\FormationAzureDevOps\AzureRepos\files>git commit -m "Initial Commit"
[master (root-commit) dffc003] Initial Commit
 1 file changed, 1 insertion(+)
 create mode 100644 sample.txt
```

# Azure Repos

- Create an empty repos in AzureDevOps
- Push an existing repository 

```console
git remote add origin https://jbdemoaks@dev.azure.com/jbdemoaks/aksdemocomplet/_git/ReposDemo
git push -u origin --all
```

# Add new modif

## modif file

```console
echo This is the sample file - Version 1 > sample.txt
```

## check state git

```console
C:\FormationAzureDevOps\AzureRepos\files>git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   sample.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

## add file in staged area

```console
git add .
```

## commit locally

```console
C:\FormationAzureDevOps\AzureRepos\files>git commit -m "second change"
[master d4c578f] second change
 1 file changed, 1 insertion(+), 1 deletion(-)
```

## push to Repos

```console
C:\FormationAzureDevOps\AzureRepos\files>git push
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 282 bytes | 282.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: Analyzing objects... (3/3) (68 ms)
remote: Storing packfile... done (55 ms)
remote: Storing index... done (64 ms)
To https://dev.azure.com/jbdemoaks/aksdemocomplet/_git/ReposDemo
   dffc003..d4c578f  master -> master
```