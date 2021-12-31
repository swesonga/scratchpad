# Github Personal Access Tokens

When trying to push a new branch on a fresh machine, this error pops up:

```
saint@ubuntuvm2-saint:~/repos/jdk$ git push --set-upstream origin dev/FixLabelOper
Username for 'https://github.com':swesonga
Password for 'https://swesonga@github.com':
remote: Support for password authentication was removed on August 13, 2021. Please use a personal access token instead.
remote: Please see https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/ for more information.
fatal: Authentication failed for 'https://github.com/swesonga/jdk/'
saint@ubuntuvm2-saint:~/repos/jdk$
```

I created the PAT and used it as the password but authentication still failed.
My only `git config --global -l` entries were related to my user name/email and git command aliases.

## Solution

Run this command after creating a PAT:

`git config --global credential.helper cache`

Now retrying the push operation succeeds. Perhaps a review of [gitcredentials](https://git-scm.com/docs/gitcredentials) might be helpful.