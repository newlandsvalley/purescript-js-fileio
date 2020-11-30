purescript-js-fileio
====================

Provide the facility for browser-based applications to read and write files to and from the local file system in a simple manner. PureScript wrappers are supplied for the JavaScript functions __readAsText__, __readAsBinaryString__ and __URL.createObjectURL__ (with a text payload). The exported functions are:

*  loadTextFile
*  loadBinaryFileAsText
*  saveTextFile

Note that __readAsBinaryString__ is effectively deprecated in javascript. As far as I can tell, it was originally dropped from the [W3C File API](https://www.w3.org/TR/FileAPI/) specification but later reappeared because of backward compatibility reasons.  The spec says that __readAsArrayBuffer__ is preferred.

If, alternatively, you intend to make use of Halogen's __onFileUpload__ event, then this treats files in terms of the [Web File](https://pursuit.purescript.org/packages/purescript-web-file/2.3.0/docs/Web.File.File#t:File) API. This approach requires the use of a subsequent __loadend__ callback which I think means that coroutines must be used if you need to get hold of the file's contents.


## To build

    spago install
    spago build

or

    bower install
    pulp build

## To build the Halogen example

cd to the halogen-example directory and run:


    npm run build


And then navigate to the __dist__ directory.
