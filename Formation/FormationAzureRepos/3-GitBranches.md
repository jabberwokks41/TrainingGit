# what are Branches in Git

- Branches help developpers to work on a different line of development and not touch the main branch of work

- create new branch for a new feature of an application

- easy to use

# example

```console

# creation de la nouvelle branche
git branch feature-123

# verification sur quelle branche on pointe
C:\FormationAzureDevOps\AzureRepos\files>git branch
  feature-123
* master

# voir le contenu du fichier sample.txt
C:\FormationAzureDevOps\AzureRepos\files>more sample.txt
This is the sample file - Version 1

# changement de la branche sur laquelle on va travailler
C:\FormationAzureDevOps\AzureRepos\files>git checkout feature-123
Switched to branch 'feature-123'

# verification sur quelle branche on pointe
C:\FormationAzureDevOps\AzureRepos\files>git branch
* feature-123
  master

# modification du fichier
C:\FormationAzureDevOps\AzureRepos\files>echo This is the feature branch > sample.txt

# ajout des modif dans la staged area
C:\FormationAzureDevOps\AzureRepos\files>git add .

# commit en local
C:\FormationAzureDevOps\AzureRepos\files>git commit -m "Feature commit"
[feature-123 d7f2620] Feature commit
 1 file changed, 1 insertion(+), 1 deletion(-)

# voir le contenu du fichier sample.txt
C:\FormationAzureDevOps\AzureRepos\files>more sample.txt
This is the feature branch

# changement de la branche sur laquelle on va travailler
C:\FormationAzureDevOps\AzureRepos\files>git checkout master
Switched to branch 'master'
Your branch is up to date with 'origin/master'.

# voir le contenu du fichier sample.txt
C:\FormationAzureDevOps\AzureRepos\files>more sample.txt
This is the sample file - Version 1

# changement de la branche sur laquelle on va travailler
C:\FormationAzureDevOps\AzureRepos\files>git checkout feature-123
Switched to branch 'feature-123'

# creation de la branche dans AzureDevOps
C:\FormationAzureDevOps\AzureRepos\files>git push
fatal: The current branch feature-123 has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin feature-123

C:\FormationAzureDevOps\AzureRepos\files>git push --set-upstream origin feature-123
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 275 bytes | 275.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: Analyzing objects... (3/3) (27 ms)
remote: Storing packfile... done (61 ms)
remote: Storing index... done (63 ms)
To https://dev.azure.com/jbdemoaks/aksdemocomplet/_git/ReposDemo
 * [new branch]      feature-123 -> feature-123
Branch 'feature-123' set up to track remote branch 'feature-123' from 'origin'.

```