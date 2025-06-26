// These are the Rirekisho data structures and functions for organizing and
// creating sections of education for a resume, such as degrees earned from
// universities or certifications.
//
// Here is a usage example:
// ```typst
// #let free-degree = Education-experience(
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
// - `date`: `str` | `content` | `datetime` | `int` | `none`
//     The date on which the degree was earned. If given as type `int`, it
//     should indicate the year in which the degree was earned.
// - `score`: `str` | `content` | `float` | `none`
//     The overall score earned for the degree. Typically this is a GPA (Grade
//     Point Average) or some scoring system for grades throughout the course of
//     study.
// - `scale`: `str` | `content` | `float` | `none`
//     The scale with which to put the `score` in perspective. Often, for GPAs,
//     this is `4.0`.
#let Education-experience(
  institution: none,
  location: none,
  kind: none,
  study: none,
  date: none,
  score: none,
  scale: none,
) = {
  return (
    institution: institution,
    location: location,
    kind: kind,
    study: study,
    date: date,
    score: score,
    scale: scale,
  )
}

// Turn an education experience into content.
//
// The education experience will be formatted as follows:
//   [`institution`]{ --- }[`location`]
//   [`kind`] [`study`]{ --- }[`score`]{/}[`scale`] ... [`date`]
// Where anything in "{}" will be inserted depending on whether both of the
// fields adjacent to it exist. Everything left of the "..." will be
// left-aligned, and everything right of it will be right-aligned.
//
// # Parameters
// - `experience`: `dictionary`
//     The experience to show, which should formatted like the one returned from
//     `Education-experience`.
// - `date-format`: `str` | `none`
//     The format string passed to `datetime.display`. If `none`, the format is
//     simply the name of the month followed by the year.
//
// # Notes
// - If no score is provided, the scale will not be displayed even if it is
//   provided.
// - Any field in the education experience that is of type `content` will not be
//   modified.
// - The `institution` field will be italicized if of type `str`. Other fields
//   of type `str` will be formatted as `text` (which may be modified via
//   `set`/`show` rules.
#let show-education-experience(experience, date-format: none) = {
  if date-format == none {
    date-format = "[month repr:short] [year]"
  }

  let result-content = none

  let (institution, location, kind, study, date, score, scale) = experience

  if type(institution) == str {
    institution = emph(institution)
  }

  // Format `date` if it's a `datetime` so it can be used as content when added
  // to the result.
  if type(date) == datetime {
    date = date.display(date-format)
  }

  if type(date) != content {
    date = emph[#date]
  }

  result-content += institution

  if result-content != none and location != none {
    result-content += [ --- ]
  }
  result-content += location

  let academic-content = none
  academic-content += kind + [ ] + study

  if academic-content != none and score != none {
    academic-content += [ --- #score]

    if scale != none {
      academic-content += [/#scale]
    }
  }

  academic-content += [#h(1fr) #date]

  result-content += list(marker: "", academic-content)

  return result-content
}

// A convenience function to gather a list of educational experiences together
// that can be displayed as a section in the resume.
//
// # Parameters
// - `title`: `str` | `content` | `none`
//     The title to display for the education section.
// - `experiences`: `arguments`
//     Experiences should be dictionaries formatted like the ones returned from
//     `Education-experience` such that it can be used in
//     `show-education-experience`. Arguments may be named or not; in either
//     case they are appended in the order in which they were passed, with the
//     named experiences first.
#let Education-section(title: "Education", ..experiences) = {
  return (
    title: title,
    unnamed-experiences: experiences.pos(),
    named-experiences: experiences.named(),
  )
}

// Turn an education section into content.
//
// # Parameters
// - `education`: `dictionary`
//     The education section to show, which should be a dictionary formatted
//     like the one returned from `Education-section`.
// - `list-marker`: `str` | `content` | `none`
//     The marker to use for the education experience list. This is directly
//     passed to `list`.
// - `date-format`: `str` | `none`
//     The date format to use for displaying education experiences. See
//     `show-education-experience` for details.
// - `should-group-institutions`: `bool`
//     Whether the experiences should be grouped by institution. The groups will
//     be ordered based on the order in which institutions are found by
//     searching through the education experiences in the order they would be
//     displayed ordinarily. This means that, for example, if experience 'A' and
//     'C' both share institution 'I1', and experience 'B' with institution 'I2'
//     was ordered between the two, the resulting group will be 'A' and 'C'
//     under 'I1' followed by 'B' under 'I2'.
//
// # Notes
// -  If the education section's title is passed as type `str`, the title will
//    be emboldened; otherwise it is left as-is.
// - See notes on `show-education-experience` for how parts of education
//   experiences are formatted depending on types, etc.
// - If the experiences are to be grouped by institution, any experience that
//   does not have an institution (e.g. it is `none`) will be ignored.
#let show-education-section(
  education,
  list-marker: "",
  date-format: none,
  should-group-institutions: false,
) = {
  let result-content = []

  let (title, unnamed-experiences, named-experiences) = education

  if type(title) == str {
    title = strong(title)
  }
  result-content += title

  let experiences = named-experiences.values() + unnamed-experiences

  if should-group-institutions {
    // TODO: clean up this branch; `institutions-map` should likely be a
    // dictionary, and can probably be created in a simpler way with the array
    // method `fold`

    // Collect a list of institutions to a corresponding list of experiences
    // (e.g. an array of 2-element arrays which consist of
    //   1. an institution
    //   2. an array of its corresponding experiences
    let institutions-map = ()

    for experience in experiences {
      let institution = experience.institution

      let position = institutions-map.position(
        group => group.first() == experience.institution
      )

      if position != none {
        let (
          group-institution,
          group-experiences,
        ) = institutions-map.at(position)

        group-experiences.push(experience)

        institutions-map.at(position) = (group-institution, group-experiences)
      } else {
        institutions-map.push((institution, (experience,)))
      }
    }

    for (institution, experiences) in institutions-map {
      result-content += list(
        marker: list-marker,
        ..experiences.enumerate().map(index-and-experience => {
          let (index, experience) = index-and-experience
          // TODO: make this not modify the input object (e.g. probably copy
          // `experience` and then update `.institution` and `.location` instead
          // of directly modify `experience`), since this could have unexpected
          // effects to callers if they expect the input to be unmodified
          if (index > 0) {
            // Setting the `institution` and `location` fields to `none` causes
            // the first line in the output from `show-education-experience` to
            // be ignored, which essentially acts as a grouping mechanism for
            // experiences since subsequent experiences show as list items below
            // the same institution heading.
            experience.institution = none
            experience.location = none
          }
          return show-education-experience(experience, date-format: date-format)
        })
      )
    }
  } else {
    for experience in experiences {
      result-content += list(
        marker: list-marker,
        show-education-experience(experience, date-format: date-format),
      )
    }
  }

  return result-content
}
