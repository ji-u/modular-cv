<h1 align="center">
	Modular CV
</h1>
<p align="center">
	A Modular, Academic Curriculum Vitae/Résumé template in XeTeX	
</p>

## Motivation

Most LaTeX Curriculum Vitae/Résumé template provide well formatted sections and entry macros to create CV/resumes with fancy looking.
However, the content and styles are highly coupled.
If one need to create different CV/resumes for different purpose, he has to do many modifications.

This template attempts to be **modular**.
Users can write their profiles such as education, work experience, and publications independently and create CV/resumes from these profiles efficiently.

## Dependencies

We require **XeTeX** for CJK font support and **BibTex** for publication and citation support.

## User Guide

### Quick Start

Simply modify the example [cv.tex](cv.tex) file and the personal information in the tex files in [content](content/) folder.

### File Structure

The main tex file in the example is [cv.tex](cv.tex). It structure is simply
```tex
\usepackage{modularcv}

% input tex files in content folder

\begin{document}
\makecvheader % create header and footer
\makefooter

\section{education} % make education section
\makeEducation

% make other sections

\end{document}
```
We can quickly change the content to display in this file. All details are defined in tex files in [content](content/) folder.

Each file in the content folder use macros like `\newXXX{key}{val1, val2, ... , valn}` to define personal information.

#### Basic information
It defines the basic information for the header to display.
```tex
\name{firstname}{lastname}
\role{your title}
\address{your address}
\email{example@email.com}
\phone{(+86)18888888888}
% The following are optional
% https://scholar.google.com/citations?user=XXXXXX
\googlescholar{XXXXXX}{your name}
% https://github.com/xxx
\github{xxx}
\homepage{https://example.com}
% any social link you expect to add
\social{<name>}[<icon>]{<url>}{<text>}
```

#### Education
Create a new education record in the content tex files
```tex
\newEducation{key}{
    {Ph.D.}, % commas are important
    {Computer Science},
    {Tsinghua University},
    {Department of Computer Science and Technology},
    {Beijing, China},
    {Sept. 2015},
    {June 2020},
    {Your advisor} % optional
}
```
Display educations in main tex file
```tex
\makeEducation
```

#### Research Experience
Create a research project record in the content tex files
```tex
\newResearchExperience{key}{
    {Project name},
    {Describe what the project aims to solve},
    {
        {highlight one},
        {highlight two}
    },
    {papercitation1, papercitation2}, % citations of papers in the project
    {ASPLOS, MICRO}, % top conference/journals the paper belongs
    {Tsinghua University} % affiliation
}
```
Display research experience in the main tex file
```tex
\makeResearchExperience
```

#### Work Experience
Create a work experience in the content tex files
```tex
\newWorkExperience{company}{
    {company name},
    {group},
    {role in the company},
    {location of the work},
    {June 2019},
    {Sept. 2019},
    {
		{Duty1 in the company},
		{Duty2 in the company}
	},
    {
		{Achievement1 in the company},
		{Achievement2 in the company}
	}
}
```
Display work experience in the main tex file
```tex
\makeWorkExperience
```

### Teaching Experience
Create a teaching experience in the content tex files
```tex
\newTeaching{assemble2019}{
    {Course name},
    {Teaching Assistant},
    {Tsinghua University},
    {Fall}, % quater
    {2019}
}
```
Display teaching experience in the main tex file
```tex
\makeTeachingExperience
```

### Award
Create an award record in the content tex files
```tex
\newAward{
    {XXX Award},
    {Agency give you the award},
    {Brief introduction of the award},
    {2019}
}
```
Display awards in the main tex file
```tex
\makeAward
```

### Publication
This is the most complicated part. Publication has different types, we support `conference`, `journal`, `workshop`, `poster`, `underreview`, `workinprogress`, and `patent` types.

Each one has a citation key that can be cited in any place of the CV.

#### Conference, Workshop, and Posters
Poster and workshop is the same as confernece, but the macro names are `\newPoster` and `\newWorkshop`.
```tex
\newConference{citationkey}
{Title of the paper}
{Author1, \makeme{Your name}, Author3}
{International Conference on XX}
{ICXX} % abbr of the conference
{2019}{3} % year and month
```

#### Journal
```tex
\newJournal{citationkey}
{Title of the paper}
{Author1, \makeme{Your name}, Author3}
{Journal Name}
{JXX} % abbr of the journal
{2019}{2} % year and month
{18}{1}{38--42} % volumn, issue, page number
```

#### Under Review & Work in Progress
Work in Progress is the same as Under Review but the macro name is `\newWorkInProgress`.
```tex
\newUnderReview{citationkey}
{Title of the paper}
{Author1, \makeme{Your name}, Author3}
{Conference or journal full name}
{Abbr} % abbr of the conference or journal
{2020} % year
```

#### Patent
```tex
\newPatent{citationkey}
{Title of the paper}
{Author1, \makeme{Your name}, Author3}
{patent number}
{2016}{x}{xx} % priority date
{2019}{x}{xx} % grant date (optional if not yet)
```

#### List Publication

```tex
\makePublication[<filter>]
```
The `<filter>` is a boolean expression to check if a publication record should be displayed here. For example, to display official publications (conference and journal papers)
```tex
\makePublication[
	\equal{\pubtype}{conference}
	\OR \equal{\pubtype}{journal}
]
```
The `\pubtype` is a property of a publication record. Available properties are listed as follows

- **`\pubtype`**: one of `conference`, `journal`, `poster`, `workshop`, `patent`, `underreview`, and `workinprogress`.
- **`\pubkey`**: citation key
- **`\pubtitle`**: publication title
- **`\pubauhtors`**: comma separated author list
- **`\pubbooktitle`**: conference, journal full name or patent id.
- **`\pubabbr`**: abbreviation of the conference or journal (not avaiable for patent)
- **`\pubyear`**: publication year (patent priority date)
- **`\pubmonth`**: publication month
- **`\pubday`**: publication day of the month
- **`\pubvolumn`**: volumn for journal
- **`\pubnumber`**: issue number for journal
- **`\pubpages`**: page numbers for journal
- **`\grantyear`**: grant year for patent
- **`\grantmonth`**: grant month for patent
- **`\grantday`**: grant day of the month for patent

The `\makePublication` can be called many times to separate different publications in different sections. It will omit those that displayed before and their numbers are continues.

#### citation
Use `\cite{<key>}` to cite the publications anywhere in the CV as usual. The corresponding publication record must be displayed by one `\makePublication`.

## Developer Guide

### Key Concepts

Curriculum Vitae/Résumés contain a `header`, `footer`, and many `section`s or `subsections`. Each section/subsection contains many `components`. There are several kinds of `components`. Each of them has many formatted texts.

All these components composed of a `BoundingBox` that defines its padding and a `Style` that defines the font size, color, fontshape, prefix/surfix of the text. Each component that contains sub-components also need to organize the position of the sub-components.

Moreover, the contents of a CV/Resume usually contains contents such as `Education`, `Work Experience`. This contents are displayed using the `sections` and `components`.

Thus, we first develop a `core` library to provide a flexible way of defining `component` library that contains the definition `header`, `footer`, `section`, `subsection`, and different kind of `components`.

Then, we can further define a `format` library to define how to store different kind of contents and how to display them with `component` library.

Next, users can define their information with the `format` library. These information can be reused for different CV/resumes.

Finally, users can write the main tex file that defines which contents to be displayed.

### File Structure
The [modularcv.cls](modularcv.cls) contains the definition of `core` library, the `component` library, and utilities.
The styles of components are defined in style file in [style](style/) folder. The style we implement is [awesome](style/awesome.sty) style, which highly reference the [Awesome-CV](https://github.com/posquit0/Awesome-CV) project.
The `format` libraries are defined in [format](format/) folder. Developers can easily add new custom formats in this folder.

### Core Library

The `core` library are all in `modularcv.cls`. It defines the basic settings such as layout, color management, and font management. It also defines some data structures to create new components more easily.

#### Color
Colors are managed by `xcolor` package.
We use `normal`, `light`, `lighter`, and `theme` as four basic colors.
`normal` is the default color

#### Font
We use `fontspec` as the backend and define a more easy to use interface as color management
```tex
\definefontfamily{<name>}[<fontspecs>]{font}
```
Then we can use `\<name>` to apply the font for a specific content
We can also define the default font by
```tex
\setdefaultfontfamily{<name>} % default roman font
\setdefaultsansfamily{<name>} % default sans font
```
User can switch between roman font and sans font by
```tex
\usepackage[sans]{modularcv}
\usepackage[serif]{modularcv}
```

#### Map & Sheet
The `map` and `sheet` are collection data structures to manage data more easily and clearly.
`map` store key-value pairs and `sheet` also stores key-record pairs. The record contains many values, each value has a corresponding column name.
Developers can develop `map` or `sheet` by macros
```tex
\definemap{<name>}
\definesheet{<name>}{<col-name-1>, ... , <col-name-n>}
```
The macros will create the following macros to access the `map` and `sheet`
```tex
% map
\new<name>{<key>}{<value>} % <value> is optional
\set<name>{<key>}{<value>}
\get<name>{<key>}
\loop<name>{<code>}
% sheet
\new<name>{<key>}{<value-1>, ... , <value-n>} % values are optional
\update<name>{<key>}{<value-1>, ... , <value-n>} % set entire record
\set<name>{<key>}{<col-name>}{<value>} % set one item in a record
\get<name>{<key>}{<col-name>}
\loop<name>{<code>}
```
The `\loop<name>{<code>}` is to traverse over the `map` or `sheet` in order (insertion order) and execute the `<code>`. The `<code>` can contain `\loopk` to refer to the `<key>`, `\loopi` to refer to the index, and `\loopv` to refer to the value.
For `sheet`, we use `\loopv{<col-name>}` to get the correponding item. `\loopbreak` is used to exit the loop.

Note `\loopv{<col-name>}` will not be expand first. If you need to use its value for further processing, you can do like the following in `<code>`.
```tex
\edef\<somename>{\loopv{<col-name>}}
% use \<somename> instead in the <code>
```
Since `\edef` will completely expand the macro, any macros stored in the sheet that do not expect to be expanded should be protected by `\noexpand`. For example
```tex
\definesheet{Content}{col1, col2}
\newContent{key1}{
	{some sentence with cite~\noexpand\cite{citekey}},
	{other sentence}
}
\loopContent{
	\edef\firstcolumn{\loopv{col1}}
	\firstcolumn
}
```

#### Style

Define a style to format a text
```tex
\definestyle{<name>}{<fontsize>,<font>,<fontshape>,<color>,<pre>,<post>}
\definestyle{<name>} % empty style
```
Set the style
```tex
\updateStyle{<name>}{<fontsize>,<font>,<fontshape>,<color>,<pre>,<post>}
\setStyle{<name>}{<property>}{<value>}
```
Apply the style
```tex
\<name>style{Hello World}
```
The properties of a style including the following

- **fontsize**: font size (e.g. 10pt)
- **font**: font defined by the style file (e.g. \lightfont)
- **fontshape**: \bfseries, \scshape, \itshape, or combination of them
- **color**: one of `normal`, `light`, `lighter`, `theme` or other colors defined by the style file
- **pre**: prefix of the content
- **post**: postfix of the content

#### Box
Define a box to set margin of a content
```tex
\definebox{<name>}{<mode>, <margin-before>, <margin-after>}
\definebox{<name>} % empty box
```
Set the box
```tex
\updateBox{<name>}{<mode>, <margin-before>, <margin-after>}
\setBox{<name>}{<property>}{<value>}
```
Apply the box
```tex
\<name>box{Hello world}
```
The properties of a box including the following

- **mode**: `h` for horizontal box and `v` for vertical box
- **margin-before**: margin before the content (e.g. 1em)
- **margin-after**: margin after the content (e.g. 1em)

Show the boxes by add debug option in the class file
```tex
\usepackage[debug]{modularcv}
```
All the box will show their boders.

#### Component

Define a new component displayed in the document
```tex
\definecomponent{<name>}{<content>, <style-name>, <box-name>}
```
Make the component in the document
```tex
\make<name>
```

### Component Library

The components are also defined in `modularcv.cls`. It contains `cvheader`, `footer`, `section`, `subsection`, and `entry` definition.

#### cvheader

To define the necessary information to create CV header
```tex
\name{firstname}{lastname}
\role{your title}
\address{your address}
\email{example@email.com}
\phone{(+86)18888888888}
% The following are optional
% https://scholar.google.com/citations?user=XXXXXX
\googlescholar{XXXXXX}{your name}
% https://github.com/xxx
\github{xxx}
\homepage{https://example.com}
% any social link you expect to add
\social{<name>}[<icon>]{<url>}{<text>}
```
These `name`, `role`, and `address` are stored in map `BasicInfo`, and the rest are stored in sheet `social`. They all has the corresponding `component` to display them. The content of cvheader are composed of the `\make<name>` of the components.

To create the header
```tex
\makecvheader
```

#### footer
We use fancyhdr to create footer. It requires the title of the file and display in the middle of the footer
```tex
\title{<title>}
```
To create the title
```tex
\makefooter
```

#### section & subsection

Usage
```tex
\section[<icon>]{<title>} % icon is optional
\subsection{<title>}
```
The `style` and `box` of section and subsection is also named `section` and `subsection`. We can change the style and margin with them.

#### entry

Usage
```tex
\entry{<title>}[<comment>]{<subtitle>}[<comment>] % subtitle and all comments are optional
```
The default looking of entry is to display `<title>` and `comment` on the left and right side of the first line and `<subtitle>` and `<subcomment>` on the second line.

The styles for the four parts are `entrytitle`, `entrycomment`, `entrysubtitle`, `entrysubcomment`.
The box for entry is `entry`.

### Format Library

We define serveral widely used format library in folder `format/`.
Users need to use the correponding package to load

#### Define your own format
A typical way is to define a sheet to store user data and create a command to create the content to display
```tex
\definesheet{xxx}{
	key1, key2, ... , keyn
}

\newcommand\makexxx{
	\loopxxx{
		% display each entry
		\entry{}[]{}[]
		\begin{itemize}
			\item xxx
		\end{itemize}
	}
}
```
Then user can define their content in a file `content/xxx.tex`
```tex
\useformat{xxx} % equivalent to \usepackage{format/xxx}
\newxxx{key}{
	val1, val2, ... , valn
}
```
And display the content in the document
```tex
\usepackage{modularcv}
\input{content/xxx.tex}
\begin{document}
% contents before
\makexxx
% contents end
\end{document}
```

Detailed formats can be seen in [User Guide](#user-guide).