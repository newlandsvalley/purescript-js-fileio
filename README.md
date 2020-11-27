purescript-js-fileio
====================

Provide the facility for browser-based applications to read and write files to and from the local file system in a simple manner. PureScript wrappers are supplied for the JavaScript functions __readAsText__, __readAsBinaryString__ and __URL.createObjectURL__ (with a text payload). The exported functions are:

*  loadTextFile
*  loadBinaryFileAsText
*  saveTextFile

Note that  __readAsText__ and __readAsBinaryString__ are effectively deprecated in javascript in favour of __Blob.text__ and __FileReader.readAsArrayBuffer__ which work by registering an event listener which fires once the data has been loaded from the file. This can be achieved in purescript by means of the Web.File API.


## To build

    spago install
    spago build

or

    bower install
    pulp build

## To build the example

Note that the example only works with purescript-pux under ps 0.12 but should give an indication of how the library may be used.  cd to the example directory and run:


    ./build.sh


And then navigate to the __dist__ directory.
