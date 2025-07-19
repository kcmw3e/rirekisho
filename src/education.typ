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

  academic-content += [#h(1fr) #style.timeframe(timeframe-content)]

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
// - `should-group-institutions`: `bool`
//     Whether the educations should be grouped by institution. The groups will
//     be ordered based on the order in which institutions are found by
//     searching through the educations in the order they would be displayed
//     ordinarily. This means that, for example, if education 'A' and 'C' both
//     share institution 'I1', and education 'B' with institution 'I2' was
//     ordered between the two, the resulting group will be 'A' and 'C' under
//     'I1' followed by 'B' under 'I2'.
//
// # Notes
// -  If the education section's title is passed as type `str`, the title will
//    be emboldened; otherwise it is left as-is.
// - See notes on `show-education` for how parts of educations are formatted
//   depending on types, etc.
// TODO: check if the below comment is actually true
// - If the educations are to be grouped by institution, any education that does
//   not have an institution (e.g. it is `none`) will be ignored.
#let show-education-section(
  education,
  datetime-format: none,
  should-group-institutions: false,
) = {
  let result = none

  let (title, unnamed-educations, named-educations) = education

  if type(title) == str {
    title = style.section(title)
  }
  result += title

  let educations = named-educations.values() + unnamed-educations

  if should-group-institutions {
    // TODO: clean up this branch; `institutions-map` should likely be a
    // dictionary, and can probably be created in a simpler way with the array
    // method `fold`

    // Collect a list of institutions to a corresponding list of educations
    // (e.g. an array of 2-element arrays which consist of
    //   1. an institution
    //   2. an array of its corresponding educations
    let institutions-map = ()

    for education in educations {
      let institution = education.institution

      let position = institutions-map.position(
        group => group.first() == education.institution
      )

      if position != none {
        let (
          group-institution,
          group-educations,
        ) = institutions-map.at(position)

        group-educations.push(education)

        institutions-map.at(position) = (group-institution, group-educations)
      } else {
        institutions-map.push((institution, (education,)))
      }
    }

    for (institution, educations) in institutions-map {
      result += list(
        ..educations.enumerate().map(index-and-education => {
          let (index, education) = index-and-education
          // TODO: make this not modify the input object (e.g. probably copy
          // `education` and then update `.institution` and `.location` instead
          // of directly modify `education`), since this could have unexpected
          // effects to callers if they expect the input to be unmodified
          if (index > 0) {
            // Setting the `institution` and `location` fields to `none` causes
            // the first line in the output from `show-education` to be ignored,
            // which essentially acts as a grouping mechanism for educations
            // since subsequent educations show as list items below the same
            // institution heading.
            education.institution = none
            education.location = none
          }
          return show-education(education, datetime-format: datetime-format)
        })
      )
    }
  } else {
    for education in educations {
      result += list(
        show-education(education, datetime-format: datetime-format),
      )
    }
  }

  return block(result)
}
