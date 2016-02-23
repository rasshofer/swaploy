# Swaploy

> Simple bash script to handle Docker deployments by swapping containers

## Usage

```shell
bash swaploy.sh myapp
```

Swaploy passes all arguments following the project name (`myapp` in the example above and below) directly to the `docker run` command. This way, you can configure your containers.

```shell
bash swaploy.sh myapp -p 8080:8080 -v /persistence/www:/var/www
```

## Example

Assuming you want to deploy your application each time you push changes in Git, you could combine Swaploy with a `post-receive` hook on your Git remote or simply by using stuff like [Webhooks](https://developer.github.com/webhooks/) (e.g. via [Captain Hook](https://github.com/rasshofer/captainhook); see JSON example below) if you’re using GitHub.

```json
[
  "cd /apps/example-app",
  "git pull origin master",
  "bash swaploy.sh myapp -p 8080:8080 -v /persistence/www:/var/www"
]
```

## Changelog

* 0.0.1
  * Initial version

## License

Copyright (c) 2016 [Thomas Rasshofer](http://thomasrasshofer.com/)  
Licensed under the MIT license.

See LICENSE for more info.
