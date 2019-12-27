### Pre-requirements to be done prior to attending the workshop

Be sure to run the following commands to ensure that you have virtualbox and vagrant installed and provisioned  
prior to attending the workshop.

Run the following commands:
```sh
$ brew cask install virtualbox
$ brew cask install vagrant
$ vagrant box add generic/ubuntu1804 --box-version 2.0.6
```

Confirm that the ubuntu image has been downloaded successfully:
```sh
$ vagrant box list
```

