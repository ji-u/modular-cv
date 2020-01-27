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

## Developer Guide

### Key Concepts

Curriculum Vitae/Résumés contain a `header`, `footer`, and many `section`s or `subsections`. Each section/subsection contains many `components`. There are several kinds of `components`. Each of them has many formatted texts.

All these components composed of a `BoundingBox` that defines its padding and a `Style` that defines the font size, color, fontshape, prefix/surfix of the text. Each component that contains sub-components also need to organize the position of the sub-components.

Moreover, the contents of a CV/Resume usually contains contents such as `Education`, `Work Experience`. This contents are displayed using the `sections` and `components`.

Thus, we first develop a `core` library to provide a flexible way of defining `component` library that contains the definition `header`, `footer`, `section`, `subsection`, and different kind of `components`.

Then, we can further define a `format` library to define how to store different kind of contents and how to display them with `component` library.

Next, users can define their information with the `format` library. These information can be reused for different CV/resumes.

Finally, users can write the main tex file that defines which contents to be displayed.

### Core Library

TODO

### Component Library

TODO

### Format Library

TODO
