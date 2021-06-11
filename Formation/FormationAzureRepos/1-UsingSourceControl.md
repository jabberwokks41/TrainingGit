# Using a versioning control system

- Developers can use a versioning control system to record changes that are made to their source code files over time

- This gives the developer the ability to revert bacj to a previous file version or even back to a previous project version

- The source code versioning system also has the ability to compare changes made to a file from one version to another

- The most popular source code versioning sytem is git

# centralized 

TFVS : Team Foundation Version Control

Developers :

1) check out the code file
2) make changes to the file in local system
3) commit changes to the server
4) an other developer can then see the reflected changes

## benefits :

its beneficial to use when you have a large code base

can specify grain permissions at the file level

you can monitor the usage of files because the check-in and check-out happens at the server level

you can also lock files if required. This would prevent these files from being changed on the server

## cons :

always need network to be connected to the server

# distribued

git

Developers :

1) Create a local copy of the entire repository
2) make change and commit locally
3) push the changes to the server
4) an other developer can then see the reflected changes

## benefits :

you are giving the developer full control over the repository by allowing to use a local copy

the developer also gets the full history along with the repository code

its great to use when you have many distributed teams (BF, DR, etc...)

Great when working with open source code bases

## cons :

more complex