## About the Container Build Image

In `testsuite/features/profiles/Docker/` we have defined 3 Dockerfiles to build
container images as test.

The Dockerfiles in `authprofile/` and `serverhost/` are based on
`registry.mgr.suse.de[:5000]/systemsmanagement/uyuni/master/docker/containers/uyuni-master-testsuite`
which is build in OBS `systemsmanagement:Uyuni:Master:Docker/uyuni-master-testsuite` .

The image is based on openSUSE Leap and install in addition some of our test packages from
the `systemsmanagement:Uyuni:Test-Packages:Pool` repositories.
The following packages are installed in this image (Version 1.0):
* andromeda-dummy
* milkyway-dummy
* virgo-dummy

While rebuilding the images we can test if the available update candidates from
our Update Repository are installed and if the UI show correct status.
