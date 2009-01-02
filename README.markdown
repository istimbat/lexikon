# Lexikon

An iPhone application to query and cache results from the online Lexin Swedish-English dictionary.

This is an application for me, Caleb Jaffa, to learn more about iPhone development and at the same time give me a handy tool to be able to translate Swedish words when I am out and about. I am an American that currently resides in Falun, Sweden.

## Status

The basic functionality works, before version 1.0 is pushed to the AppStore I'm going to add to and polish the user interface. Searching activity indicator, alert messages for failed searches, about view, save and load state of the application.

For version 1.1 I want to refactor the model and controllers. There is too much model logic in the controllers. The plan is to use a class CJLexikonLanguage to handle the word list and other data for a language which will use a class much like the existing Word, but renamed CJWord. This should greatly simplify the LexikonAppDelegate and MainViewController. It will also help application launch times as it would ease lazy loading the word lists.

## Code Contributions

Lexikon is using [Gus Mueller](http://gusmueller.com/)'s [FMDB](http://gusmueller.com/blog/archives/2008/06/new_home_for_fmdb.html) adapter for managing talking with the SQLite database.

## License

Copyright (c) 2009 Caleb Jaffa

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.