%%
%% This is file `modularcv.cls'.
%% Copyright (C) 2020-2020 by Yu Ji <maple.jiyu@hotmail.com>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{modularcv}
[2020/01/23 v0.0.1 modular academic curriculum vitae]
\DeclareOption{sans}{\renewcommand\familydefault\sfdefault}
\DeclareOption{serif}{\renewcommand\familydefault\rmdefault}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\def\option@mode{final}}
\DeclareOption{debug}{\def\option@mode{debug}}
\ExecuteOptions{a4paper,10pt,final}
\ProcessOptions\relax
\LoadClass{article}
\RequirePackage{xifthen}
% utilities
%----------------------------------------------------
% if empty
\newcommand\IfEmptyF[2]{\ifthenelse{\equal{#1}{}}{}{#2}}
\newcommand\IfEmptyTF[3]{\ifthenelse{\equal{#1}{}}{#2}{#3}}
%====================================================
% Core Library
%====================================================
\RequirePackage{xparse}
% map data structure
%----------------------------------------------------
\newcounter{map@iterator}
% create a map
% usage: \definemap{<name>}
\newcommand\definemap[1]{%
	\newcounter{map@#1@size}%
	\expandafter\newcommand\csname new#1\endcsname[2]{%
		\map@insert{#1}{##1}{##2}}%
	\expandafter\newcommand\csname set#1\endcsname[2]{%
		\map@set{#1}{##1}{##2}}%
	\expandafter\newcommand\csname get#1\endcsname[1]{%
		\map@get{#1}{##1}}%
	\expandafter\newcommand\csname loop#1\endcsname[1]{%
		\map@loop{#1}{##1}}}
% insert a new key value pair into the map
% usage: \map@insert{<name>}{<key>}{<value>}
\newcommand\map@insert[3]{%
	\map@set{#1}{#2}{#3}%
	\expandafter\def\csname map@#1@key@\roman{map@#1@size}\endcsname{#2}%
	\stepcounter{map@#1@size}}
% set the value of a existing key
% usage: \map@set{<name>}{<key>}{<value>}
\newcommand\map@set[3]{\expandafter\def\csname map@#1@val@#2\endcsname{#3}}
% get the value of a existing key
% usage: \map@get{<name>}{<key>}
\newcommand\map@get[2]{%
	\ifcsname map@#1@val@#2\endcsname%
		\csname map@#1@val@#2\endcsname%
	\fi}
% loop over a map
% usage: \map@loop{<name>}{<code>}
\newcommand\map@loop[2]{%
	\setcounter{map@iterator}{0}%
	\loop\ifnum\value{map@iterator}<\value{map@#1@size}%
		\edef\loopi\arabic{map@iterator}%
		\edef\loopk\csname map@#1@key@\roman{map@iterator}\endcsname%
		\edef\loopv\map@get{#1}{\loopk}%
		#2%
		\stepcounter{map@iterator}\repeat}
% sheet data structure
%----------------------------------------------------
\newcounter{sheet@row@iterator}
\newcounter{sheet@col@iterator}
% create a new sheet
% usage: \definesheet{<name>}{<colkey-1>, ... , <colkey-n>}
\ExplSyntaxOn
\newcommand\definesheet[2]{%
	\newcounter{sheet@#1@rows}%
	\newcounter{sheet@#1@cols}%
	\clist_map_inline:nn{#2}{%
		\expandafter\def\csname%
			sheet@#1@colkey@\roman{sheet@#1@cols}%
		\endcsname{##1}%
		\stepcounter{sheet@#1@cols}}%
	\expandafter\NewDocumentCommand\csname new#1\endcsname{mG{}}{%
		\sheet@insert{#1}{##1}{##2}}%
	\expandafter\newcommand\csname update#1\endcsname[2]{%
		\sheet@update{#1}{##1}{##2}}%
	\expandafter\newcommand\csname set#1\endcsname[3]{%
		\sheet@set{#1}{##1}{##2}{##3}}%
	\expandafter\newcommand\csname get#1\endcsname[2]{%
		\sheet@get{#1}{##1}{##2}}%
	\expandafter\newcommand\csname loop#1\endcsname[1]{%
		\sheet@loop{#1}{##1}}}
\ExplSyntaxOff
% insert a record in the sheet
% usage: \sheet@insert{<name>}{<key>}{<colval-1>, ... , <colval-n>}
\newcommand\sheet@insert[3]{%
	\expandafter\def\csname%
		sheet@#1@rowkey@\roman{sheet@#1@rows}%
	\endcsname{#2}%
	\stepcounter{sheet@#1@rows}%
	\sheet@update{#1}{#2}{#3}}
% update a record in the sheet
% usage: \sheet@update{<name>}{<key>}{<colval-1>, ..., <colval-n>}
\ExplSyntaxOn
\newcommand\sheet@update[3]{%
	\setcounter{sheet@col@iterator}{0}%
	\loop\ifnum\value{sheet@col@iterator}<\value{sheet@#1@cols}%
		\edef\@colkey{%
			\csname sheet@#1@colkey@\roman{sheet@col@iterator}\endcsname}%
		\expandafter\def\csname sheet@#1@row@#2@col@\@colkey\endcsname{}%
		\stepcounter{sheet@col@iterator}\repeat%
	\setcounter{sheet@col@iterator}{0}%
	\clist_map_inline:nn{#3}{%
		\edef\@colkey{%
			\csname sheet@#1@colkey@\roman{sheet@col@iterator}\endcsname}%
		\expandafter\def\csname sheet@#1@row@#2@col@\@colkey\endcsname{##1}%
		\stepcounter{sheet@col@iterator}}}
\ExplSyntaxOff
% set an item in a record in the sheet
% usage: \sheet@set{<name>}{<rowkey>}{<colkey>}{<value>}
\newcommand\sheet@set[4]{%
	\expandafter\def\csname sheet@#1@row@#2@col@#3\endcsname{#4}}
% get an item in a record in the sheet
% usage: \sheet@get{<name>}{<rowkey>}{<colkey>}
\newcommand\sheet@get[3]{%
	\ifcsname sheet@#1@row@#2@col@#3\endcsname%
		\csname sheet@#1@row@#2@col@#3\endcsname%
	\fi}
% loop over a sheet
% usage: \sheet@loop{<name>}{<code>}
\newcommand\sheet@loop[2]{%
	\setcounter{sheet@row@iterator}{0}%
	\loop\ifnum\value{sheet@row@iterator}<\value{sheet@#1@rows}%
		\edef\loopi{\arabic{sheet@row@iterator}}%
		\edef\loopk{%
			\csname sheet@#1@rowkey@\roman{sheet@row@iterator}\endcsname}%
		\def\loopv{\sheet@get{#1}{\loopk}}%
		#2%
		\stepcounter{sheet@row@iterator}\repeat}
% layout configuration
%----------------------------------------------------
\RequirePackage{fancyhdr}
\RequirePackage{geometry}
\geometry{%
	left	= 1.2cm,
	top		=  .8cm,
	right	= 1.2cm,
	bottom	= 1.8cm,
	footskip=  .5cm,
}
\fancyhfoffset{0em}
\fancyhf{}
\pagestyle{fancy}
\setlength\parindent{0pt}
\setlength\parskip{.5em}
% color settings
%----------------------------------------------------
\RequirePackage{xcolor}
\definecolor{black}{HTML}{000000}
% four colors: normal, light, lighter, and theme color
\colorlet{normal}{black}
\colorlet{light}{black}
\colorlet{lighter}{black}
\colorlet{theme}{black}
% font settings
%----------------------------------------------------
\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\definesheet{FontFamily}{font, spec}
% create a new font family
% usage: \definefontfamily{<name>}[O<spec>]{<font>}
\NewDocumentCommand\definefontfamily{mO{}m}{\newFontFamily{#1}{{#3},{#2}}}
% add an alias of a defined font family
% usage: \fontfamilylet{<new>}{<old>}
\newcommand\fontfamilylet[2]{%
	\newFontFamily{#1}{%
		{\getFontFamily{#2}{font}},{\getFontFamily{#2}{spec}}}}
% set default fonts
\newcommand\setdefaultfontfamily[1]{\fontfamilylet{serif}{#1}}
\newcommand\setdefaultCJKfontfamily[1]{\fontfamilylet{CJKserif}{#1}}
\newcommand\setdefaultsansfamily[1]{\fontfamilylet{sans}{#1}}
\newcommand\setdefaultCJKsansfamily[1]{\fontfamilylet{CJKsans}{#1}}
% Configure default style
%----------------------------------------------------
\RequirePackage{etoolbox}
\RequirePackage{xifthen}
\AtBeginDocument{\color{normal}}
\AtEndPreamble{\loopFontFamily{%
	\ifthenelse{\equal{\loopk}{serif}}{%
		\setmainfont[\loopv{spec}]{\loopv{font}}}{%
	\ifthenelse{\equal{\loopk}{CJKserif}}{%
		\setCJKmainfont[\loopv{spec}]{\loopv{font}}}{%
	\ifthenelse{\equal{\loopk}{sans}}{%
		\setsansfont[\loopv{spec}]{\loopv{font}}}{%
	\ifthenelse{\equal{\loopk}{CJKsans}}{%
		\setCJKsansfont[\loopv{spec}]{\loopv{font}}}{%
		\expandafter\newfontfamily\csname\loopk\endcsname[%
			\loopv{spec}]{\loopv{font}}}}}}}}
% component styles
%----------------------------------------------------
\definesheet{Style}{fontsize,font,fontshape,color,pre,post}
% format content with a style
% usage: \style@apply{<name>}{<content>}
\newcommand\style@apply[2]{{%
	\def\@fontsize{\getStyle{#1}{fontsize}}%
	\def\@font{\getStyle{#1}{font}}%
	\def\@fontshape{\getStyle{#1}{fontshape}}%
	\def\@color{\getStyle{#1}{color}}%
	\def\@pre{\getStyle{#1}{pre}}%
	\def\@post{\getStyle{#1}{post}}%
	\IfEmptyF{\@fontsize}{\fontsize{\@fontsize}{1em}\selectfont}%
	\@font\@fontshape%
	\IfEmptyF{\@color}{\color{\@color}}%
	{\@pre#2\@post}}}
% create a new style
% usage: \definestyle{<name>}{G<spec>}
\NewDocumentCommand\definestyle{mG{}}{%
	\newStyle{#1}{#2}%
	\expandafter\newcommand\csname #1style\endcsname[1]{\style@apply{#1}{##1}}}
% create many empty styles
% usage: \definestyles{<name-1>, ... , <name-n>}
\ExplSyntaxOn
\newcommand\definestyles[1]{\clist_map_inline:nn{#1}{\definestyle{##1}}}
\ExplSyntaxOff
% boxes
%----------------------------------------------------
\definesheet{Box}{mode, before, after}
\setlength\fboxsep{0pt}%
\ifthenelse{\equal\option@mode{debug}}{%
	\setlength\fboxrule{.1pt}}{%
	\setlength\fboxrule{0pt}}
% apply the box
% usage: \box@apply{<name>}{<content>}
\NewDocumentCommand\box@apply{mm}{%
	\def\@mode{\getBox{#1}{mode}}%
	\def\@before{\getBox{#1}{before}}%
	\def\@after{\getBox{#1}{after}}%
	\ifthenelse{\equal{\@mode}{h}}{\fbox{%
		\IfEmptyF{\@before}{\hspace\@before}%
		#2%
		\IfEmptyF{\@after}{\hspace\@after}%
	}}{\fbox{%
		\begin{minipage}{\linewidth}%
			\IfEmptyF{\@before}{\vspace\@before}%
			#2%
			\IfEmptyF{\@after}{\vspace\@after}%
	\end{minipage}%
	}}}
% create a new box
% usage: \definebox{<name>}{G<spec>}
\NewDocumentCommand\definebox{mG{h}}{%
	\newBox{#1}{#2}%
	\expandafter\newcommand\csname #1box\endcsname[1]{\box@apply{#1}{##1}}}
% create many empty boxes
\ExplSyntaxOn
\newcommand\definehboxes[1]{\clist_map_inline:nn{#1}{\definebox{##1}{h}}}
\newcommand\definevboxes[1]{\clist_map_inline:nn{#1}{\definebox{##1}{v}}}
\ExplSyntaxOff
% components
\definesheet{Component}{content, style, box}
% make component
% usage: \make{<name>}
\newcommand\make[1]{%
	\def\@style{\getComponent{#1}{style}}%
	\def\@box{\getComponent{#1}{box}}%
	\def\@content{\getComponent{#1}{content}}%
	\IfEmptyF{\@box}{\box@apply{\@box}}%
	{\IfEmptyF{\@style}{\style@apply{\@style}}%
	{\@content}}}
% define component
% usage: \definecomponent{<name>}{<spec>}
\newcommand\definecomponent[2]{%
	\newComponent{#1}{#2}%
	\expandafter\newcommand\csname make#1\endcsname{\make{#1}}}
%====================================================
% Component Library
%====================================================
\RequirePackage[hidelinks,unicode]{hyperref}
% Basic information
%----------------------------------------------------
\definemap{BasicInfo}
% define name
% usage: \name{<firstname>}{<lastname>}
\newcommand\name[2]{\newBasicInfo{firstname}{#1}\newBasicInfo{lastname}{#2}}
% define role
\newcommand\role[1]{\newBasicInfo{role}{#1}}
% define address
\newcommand\address[1]{\newBasicInfo{address}{#1}}
% Social information
%----------------------------------------------------
\definesheet{Social}{url, text}
\definemap{SocialIcon}
% add a social link
% usage: \social{<name>}[<icon>]{<url>}{<text>}
\definestyle{social}
\definebox{social}
\NewDocumentCommand\social{momm}{%
	\newSocial{#1}{{#3},{#4}}%
	\definecomponent{#1}{%
		\IfNoValueTF{#2}{\IfEmptyTF{\getSocialIcon{#1}}{#1:~}{\getSocialIcon{#1}~}}{#2~}%
		\href{#3}{#4}, social, social}%
}
\newcommand\email[1]{\social{Email}{mailto:#1}{#1}}
\newcommand\phone[1]{\social{Phone}{tel:#1}{#1}}
\newcommand\homepage[1]{\social{Homepage}{#1}{#1}}
\newcommand\googlescholar[2]{\social{GoogleScholar}{%
	https://scholar.google.com/citations?user=#1}{#2}}
\newcommand\github[1]{\social{Github}{https://github.com/#1}{#1}}
% make cvheader
%----------------------------------------------------
\definestyles{firstname, lastname, name, role, address, socials, header}
\definehboxes{firstname, lastname, name, role, address}
\definevboxes{header, socials}
\definecomponent{firstname}{\getBasicInfo{firstname}, firstname, firstname}
\definecomponent{lastname}{\getBasicInfo{lastname}, lastname, lastname}
\definecomponent{name}{{\makefirstname\space\makelastname}, name, name}
\definecomponent{role}{\getBasicInfo{role}, role, role}
\definecomponent{address}{\getBasicInfo{address}, address, address}
\definecomponent{socials}{%
	\centering%
	\loopSocial{\ifthenelse{\equal{\loopi}{0}}{}{\quad\textbar\quad}%
		\make{\loopk}}\\, socials, socials}
\definecomponent{cvheader}{%
	\centering%
	\makename\\
	\makerole\\
	\makeaddress\\
	\makesocials\\, header, header}
% make footer
%----------------------------------------------------
\RequirePackage[nodayofweek]{datetime}
\definestyle{footer}
\definebox{footer}
\definecomponent{date}{\today, footer, footer}
\definecomponent{foottitle}{\@title, footer, footer}
\definecomponent{pagenumber}{\thepage, footer, footer}
\newcommand\makefooter{%
	\fancyfoot{}%
	\fancyfoot[L]{\makedate}%
	\fancyfoot[C]{\makefoottitle}%
	\fancyfoot[R]{\makepagenumber}%
}
% section
%----------------------------------------------------
\definestyles{section, subsection}
\definevboxes{section, subsection}
\RenewDocumentCommand\section{om}{%
	\par\sectionbox{%
		\phantomsection{}\addcontentsline{toc}{section}{#2}%
		\IfNoValueTF{#1}{\sectionstyle{#2}}{\sectionstyle{#1~#2}}}%
	\par\@afterheading}
\renewcommand\subsection[1]{%
	\par\subsectionbox{%
		\phantomsection{}\addcontentsline{toc}{subsection}{#1}%
		\subsectionstyle{#1}}
	\par\@afterheading}
% entry
%----------------------------------------------------
\RequirePackage{enumitem}
\setlist[itemize]{label={$\circ$\space},leftmargin=4ex,noitemsep,topsep=0pt}
\definestyles{entry, entrytitle, entrycomment, entrysubtitle, entrysubcomment}
\definevboxes{entry}
% a simple entry with a title on the left and a location/date on the right
% usage: \entry{<title>}[O<comment>]{G<subtitle>}[O<subcomment>]
\NewDocumentCommand\entry{mO{}gO{}}{%
	\par\entrybox{\entrystyle{%
		\entrytitlestyle{#1}\hfill\entrycommentstyle{#2}%
		\IfNoValueF{#3}{\\\entrysubtitlestyle{#3}\hfill\entrysubcommentstyle{#4}}}}%
	\par\@afterheading}
% style loader
%----------------------------------------------------
\newcommand\usestyle[1]{\usepackage{style/#1}}
%====================================================
% Format Library
%====================================================
\newcommand\useformat[1]{\usepackage{format/#1}}