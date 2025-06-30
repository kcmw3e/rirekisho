// These are the Rirekisho data structures and functions for organizing and
// creating sections of projects for a resume.
//
// Here is a usage example:
// ```typst
// #let hello-world = Project(
//   title:  "Hello World",
//   location: "Earth",
//   start:    datetime(year: 2042, month: 01, day: 01),
//   end:      datetime(year: 2042, month: 01, day: 02),
// )[
// - I wrote "Hello, World!" in `typst` and produced a PDF file greeting the
//     whole world.
// ]
//
// #let projects = Project-section(hello-world)
//
// #show-project-section(projects)
// ```
// -----------------------------------------------------------------------------

#import "timeframe.typ": show-timeframe

// Define a project.
//
// # Parameters
// - `title`: `str` | `content` | `none`
//     The title of the project.
// - `location`: `str` | `content` | `none`
//     The location where the project was completed. It can be anything from a
//     state, province, prefecture, school, a full address, or any description
//     of the location. If the project wasn't completed as part of an
//     organization and was personal, this field can be instead listed as
//     `"Personal"` or just left empty.
// - `start`: `str` | `content` | `datetime` | `none`
//     The start date of the project.
// - `end`: `str` | `content` | `datetime` | `none`
//     The end date of the project. If this is an ongoing project, putting
//     simply `"Present"` should be satisfactory.
// - `body`: `content`
//     The content to provide when showing the project in the resume. This is
//     typically a bulleted list of information about the project, but it may
//     also be any content that adequately describes the project.
//
// # Notes
// - If the project was completed during a standard period of time (e.g. a
//   given semester of school), `end` can be left as `none` while passing
//   `start` as `content` or `str` (for example, `"Spring 2042"`).
#let Project(title: none, location: none, start: none, end: none,  body) = {
  return (title: title, location: location, start: start, end: end, body: body)
}


// Turn a project into content.
//
// The project will be formatted as follows:
//   [`title`]{ --- }[`location`] ... [`start`]{--}[`end`]
//   [body]
// Where anything in "{}" will be inserted depending on whether both of the
// fields adjacent to it exist. The exception is that the en-dash between the
// start and end dates will be inserted even if only one of the fields exists.
// Everything left of the "..." will be left-aligned, and everything right of it
// will be right-aligned.
//
// # Parameters
// - `project`: `dictionary`
//     The project to show; it should be a dictionary formatted like the one
//     returned from `Project`.
// - `date-format`: `str` | `none`
//     The format string passed to `datetime.display`. If `none`, the format is
//     simply the name of the month followed by the year. This only takes effect
//     when a project `start` or `end` field is a `datetime` and gets ignored
//     otherwise.
//
// # Notes
// - Any field in the project that is of type `content` will not be modified.
// - The `title` field will be italicized if of type `str`. Other fields  of
//   type `str` will be formatted as `text` (which may be modified via
//   `set`/`show` rules.
#let show-project(project, date-format: none) = {
  let result-content = none

  let (title, location, start, end, body) = project

  if type(title) == str {
    title = emph(title)
  }

  result-content += title

  if result-content != none and location != none {
    result-content += [ --- ]
  }

  result-content += location

  let timeframe = show-timeframe(
    start: start,
    end: end,
    date-format: date-format,
  )

  if timeframe != none {
    result-content += h(1fr)
  }

  result-content += timeframe

  if body != none {
    result-content += parbreak()
  }

  result-content += body

  return result-content
}


// A convenience function to gather a list of projects together that can be
// displayed as a section in the resume.
//
// # Parameters
// - `title`: `str` | `content` | `none`
//     The title to display for the project section.
// - `projects`: `arguments`
//     Projects should be dictionaries formatted like the ones returned from
//     `Project` such that it can be used in `show-project`. Arguments may be
//     named or not; in either case they are appended in the order in which they
//     were passed, with the named projects first.
#let Project-section(title: none, ..projects) = {
  return (
    title: title,
    unnamed-projects: projects.pos(),
    named-projects: projects.named(),
  )
}

// Turn a project section into content.
//
// # Parameters
// - `projects`: `dictionary`
//     The project section to show, which should be a dictionary formatted like
//     the one returned from `Project-section`.
// - `list-marker`: `str` | `content` | `none`
//     The marker to use for the project list. This is directly passed to
//     `list`.
// - `date-format`: `str` | `none`
//     The date format to use for displaying projects. See `show-project` for
//     details.
//
// # Notes
// -  If the project section's title is passed as type `str`, the title will be
//    emboldened; otherwise it is left as-is.
// - See notes on `show-project` for how parts of projects are formatted
//   depending on types, etc.
#let show-project-section(projects, list-marker: none, date-format: none) = {
  let result-content = none

  let (title, unnamed-projects, named-projects) = projects

  if type(title) == str {
    title = strong(title)
  }
  result-content += title

  let projects = named-projects.values() + unnamed-projects

  result-content += list(
    marker: list-marker,
    ..projects.map(project =>
      show-project(project, date-format: date-format)
    ),
  )

  return result-content
}
