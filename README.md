# DOCKER file for deploying kbs_backend

## Why Docker or --CONTAINERIZATION-- in the first place

It is all about automation, automation and automation. Thinking about dockerizing / containerizing your apps as writing scripts, but at **system** / OS levels.

- The assumption is loose: any linux / unix or platform that is supported by Docker will do.

- The output is universal. Literally everything from dependencies to environment variables to system packages will be exactly the same everywhere once you deployed your Docker containers.

- Write it once, run everywhere. (Hello Java!)

- Suppose you want to switch from AWS to Google Cloud or some hosted like Linode or Digital Ocean. Just thinking about checking out the document that you wrote to set up your app (if you did document!) and modifying it to make it work **again** on another platform is enough to despair!

*However*: donot expect a first time easy setup, especially when you just learn to use Docker. In fact, the amount of effort that I spent configuring / building containers would roughly equal to the accumulated amount I spent seperately on all platforms.

*But*: from the second time setting up your containerized app onward, you will definitely love the convenience and systematic approach that you learnt using Docker!

## Quirks

### Why using 0.0.0.0 in uwsgi.init and NOT 127.0.0.1

Short answer:
- 127.0.0.1 will serve within your container ONLY
- 0.0.0.0 will let your host (or any outsiders that you allowed) see it

Long answers:
- [Loopback, class A ip addresses](https://stackoverflow.com/questions/26423984/unable-to-connect-to-flask-app-on-docker-from-host)
- [Ip addresses](http://qr.ae/TU8V5q)

### Becareful to quote / unquoted variables in shell scripts / compose.yaml / env files
[Read it here](https://github.com/docker/compose/issues/2854)

Basically do not use quotes in env files cause quotes will be literally interpreted as part of the vars

## Docker frequently used commands
[Cheat Sheet](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

`docker images`: view main images, excluding the intermediate ones

`docker images -a`: view all images

`docker ps`: view main containers, excluding the intermediate ones

`docker ps -a`: view all images

`docker stop [id or name]`: stop running containers

`docker rmi $(docker images -a -q)`: remove all images

`docker system prune -a`: remove all dangling/un-dangling images, stopped containers

`docker run [-p HOST_PORT:CONTAINER_PORT] container`: run container binding host ports to container ports

## Git rewriting histories with git-rebase and bfg
[Reference here](https://rtyley.github.io/bfg-repo-cleaner/)


To remove specific sensitive data, be it files or file contents, from repositories, first:
- Clone the repo into a new mirrored-repo (not a repo) `git clone --mirror git://example.com/some-big-repo.git`
- Install bfg from [https://github.com/rtyley/bfg-repo-cleaner](https://github.com/rtyley/bfg-repo-cleaner)
- Remove what-need-to-be-removed with:
    + text `bfg --replace-text passwords.txt  my-repo.git`
    + files `bgf --delete-files id_{dsa,rsa}  my-repo.git`
    + folders `bfg --delete-folders .git`
- Change directory to the mirrored-repo and run:
    + `cd some-big-repo.git`
    + `git reflog expire --expire=now --all && git gc --prune=now --aggressive`
    + `git push`
- To be completely safe and clean:
    + Revoke all exposed api keys and secrets
    + Removed hosted repositories
    + Create new repo and push the clean to the hosted
    + Rewrite git histories with `git rebase`

To clean up empty commits due to bfg removals:
- Remove empty commits `git filter-branch --prune-empty`
- Delete the hosted (github?) repo and recreate it using the samename (or else you have to `git remote remove origin` and `git remote add origin {repo_url}` just like when you create it the first time)

If you want to, in great details, rewrite the histories (logs, changes, commits) of a repo:
- Git rebase **at the same commit** `git rebase -i {commit_id} --onto {commit_id}`
