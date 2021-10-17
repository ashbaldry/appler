This release fixes test issues on CRAN pointed out by the CRAN team. A couple of the tests checked a volitile metric in the web page, and so one of the tests failed. The failing tests have been removed, however there are tests covering the same piece of functionality.
There has also been removal of package dependencies, where the dependent package is used only once.
