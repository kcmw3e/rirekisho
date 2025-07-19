// These are the Rirekisho data structures and functions for organizing and
// creating sections of education for a resume, such as degrees earned from
// universities or certifications.
//
// Here is a usage example:
// ```typst
// #let free-degree = Education(
//   institution: "Anonymous University",
//   location: "Nowhere",
//   kind: "PhD",
//   study: "Omniscience",
//   date: datetime(year: 2042, month: 5, day: 1),
//   score: $infinity$,
//   scale: $infinity$,
// )
//
// #let education = Education-section(free-degree)
//
// #show-education-section(education)
// ```
// -----------------------------------------------------------------------------

#import "style.typ"
#import "timeframe.typ": show-timeframe

// Define a course of study, such as a degree earned at a university or a
// certification, etc.
//
// # Parameters
// - `institution`: `str` | `content` | `none`
//     The institution which bestowed the degree of study.
// - `location`: `str` | `content` | `none`
//     The location of the institution or where the education was received.
// - `kind`: `str` | `content` | `none`
//     The kind of education earned, typically `"B.S."`, `"M.A."`, etc.; though
//     any kind of education can probably be represented.
// - `study`: `str` | `content` | `none`
//     The area of study during the course of education, such as a major.
// - `timeframe`: `datetime` | `dictionary` | `array` | `any`
//     The timeframe in which the education was completed. It may be any valid
//     data type that can be passed to `show-timeframe`.
// - `score`: `str` | `content` | `float` | `none`
//     The overall score earned for the degree. Typically this is a GPA (Grade
//     Point Average) or some scoring system for grades throughout the course of
//     study.
// - `scale`: `str` | `content` | `float` | `none`
//     The scale with which to put the `score` in perspective. Often, for GPAs,
//     this is `4.0`.
#let Education(
  institution: none,
  location: none,
  kind: none,
  study: none,
  timeframe: none,
  score: none,
  scale: none,
) = {
  return (
    institution: institution,
    location: location,
    kind: kind,
    study: study,
    timeframe: timeframe,
    score: score,
    scale: scale,
  )
}

// Turn an education into content.
//
// The education will be formatted as follows:
//   [`institution`]{ --- }[`location`]
//   [`kind`] [`study`]{ --- }[`score`]{/}[`scale`] ... [`date`]
// Where anything in "{}" will be inserted depending on whether both of the
// fields adjacent to it exist. Everything left of the "..." will be
// left-aligned, and everything right of it will be right-aligned.
//
// # Parameters
// - `education`: `dictionary`
//     The education to show, which should formatted like the one returned from
//     `Education`.
// - `datetime-format`: `str` | `none`
//     The format string passed to `datetime.display`. If `none`, the format is
//     simply the name of the month followed by the year.
//
// # Notes
// - If no score is provided, the scale will not be displayed even if it is
//   provided.
// - Any field in the education that is of type `content` will not be modified.
// - The `institution` field will be italicized if of type `str`. Other fields
//   of type `str` will be formatted as `text` (which may be modified via
//   `set`/`show` rules.
#let show-education(education, datetime-format: none) = {
  let result = none

  let (institution, location, kind, study, timeframe, score, scale) = education

  if type(institution) == str {
    institution = style.element(institution)
  }

  let timeframe-content = show-timeframe(
    timeframe: timeframe,
    format: datetime-format,
  )

  result += institution

  if result != none and location != none {
    result += [ --- ]
  }
  result += style.location(location)

  let academic-content = none
  academic-content += kind + [ ] + study

  if academic-content != none and score != none {
    academic-content += [ --- #score]

    if scale != none {
      academic-content += [/#scale]
    }
  }

  result += [#h(1fr) #style.timeframe(timeframe-content)]

  result += list(academic-content)

  return block(result)
}

// A convenience function to gather a list of educations together that can be
// displayed as a section in the resume.
//
// # Parameters
// - `title`: `str` | `content` | `none`
//     The title to display for the education section.
// - `educations`: `arguments`
//     Educations should be dictionaries formatted like the ones returned from
//     `Education` such that it can be used in `show-education`. Arguments may
//     be named or not; in either case they are appended in the order in which
//     they were passed, with the named educations first.
#let Education-section(title: "Education", ..educations) = {
  return (
    title: title,
    unnamed-educations: educations.pos(),
    named-educations: educations.named(),
  )
}

// Turn an education section into content.
//
// # Parameters
// - `education`: `dictionary`
//     The education section to show, which should be a dictionary formatted
//     like the one returned from `Education-section`.
// - `date-format`: `str` | `none`
//     The date format to use for displaying educations. See `show-education`
//     for details.
//
// # Notes
// -  If the education section's title is passed as type `str`, the title will
//    be emboldened; otherwise it is left as-is.
// - See notes on `show-education` for how parts of educations are formatted
//   depending on types, etc.
#let show-education-section(
  education,
  datetime-format: none,
) = {
  let result = none

  let (title, unnamed-educations, named-educations) = education

  if type(title) == str {
    title = style.section(title)
  }
  result += title

  let educations = named-educations.values() + unnamed-educations

  for education in educations {
    result += list(
      show-education(education, datetime-format: datetime-format),
    )
  }

  return block(result)
}
