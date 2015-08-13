# Sanguine: An implementation of Git in Ruby

Sanguine is a hobby project to implement the Git revision control system in Ruby.

Why would I do that? Mostly to learn the Ruby way of doing things. 

Following are the aims of this project:

* Allow Git repositories to be created by Sanguine that can be read and manipulated by actual Git
* Allow Sanguine to read and manipulate repositories created by Git. Thus Sanguine and Git should be interchangeable.
* Initial aim is to implement a few commands that are most commonly used in Git. Git has the concept of "plumbing" vs "porcelein" commands, where the plumbing commands carry most of the functionality. Initial plan is to not look at plumbing commands though that decision might change depending on how the project evolves.

WARNING: DO NOT USE THIS PROJECT FOR ACTUAL VERSION CONTROL. YOU DO NOT WANT YOUR VCS TO BE EXPERIMENTAL CODE. Use official versions of Git.

License: The project is licensed under the GNU General Public License version 2 and only that version. Refer to http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.

