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

To fix this error:

1. Create the PAT as described at https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
2. Run the git command that needs authentication.
3. Close the login window that pops up (on Windows).
4. Enter your user name and then use the PAT as the password.

These steps failed the first time I tried them. I noticed that my only `git config --global -l` entries were related to my user name/email and git command aliases. To address this error, I ran this command after creating a PAT:

`git config --global credential.helper cache`

Now retrying the push operation succeeded. Perhaps a review of [gitcredentials](https://git-scm.com/docs/gitcredentials) might be helpful.