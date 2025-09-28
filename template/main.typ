#import "@preview/resumania:1.0.0": *

#let author = "John Doe"

#let contacts = Contact-section(
  phone: Phone("+0 (123) 555-0123"),
  email: Email("john.doe@example.com"),
  linkedin: Link("LinkedIn", "example", "https://linkedin.com"),
  github: Link("GitHub", "example", "https://github.com")
)

#let education = Education-section(
  masters: Education(
    institution: "Some School",
    location: "Anywhere",
    kind: "M.S.",
    study: "Mechanical Engineering",
    timeframe: datetime(year: 2042, month: 4, day: 2),
    score: 3.44,
    scale: 4.0,
  ),
  undergrad: Education(
    institution: "Another School",
    location: "The other place",
    kind: "B.S.",
    study: "Physics",
    timeframe: 2044,
    score: 3.11,
    scale: 4.0,
  ),
)

#let work = Work-section(
  Work(
    company: "Some Company",
    location: "Anywhere",
    position: "Mechanical Designer",
    timeframe: (
      start: datetime(year: 2045, month: 08, day: 08),
      end: "Present",
    )
  )[
    - Designed parts to go on aircraft for the future.
    - Ran simulations to ensure parts would meet factors of safety so the final
        product could pass standards.
    - Worked with customers to generate specifications and requirements for the
        aircraft and its features.
  ],
  Work(
    company: "A Different Company",
    location: "Somewhere Else",
    position: "Mechanical Engineer Intern",
    timeframe: (
      start: datetime(year: 2040, month: 06, day: 01),
      end: datetime(year: 2040, month: 08, day: 20),
    )
  )[
    - Performed calculations and simulations for structural elements to a space
        elevator that could carry 2 tons of payload.
    - Provided feedback to other engineers regarding the physics behind a space
        elevator and material requirements so it doesn't berak.
  ],
)

#let projects = Project-section(
  Project(title: "Automatic Pancake Flipper", timeframe: 2044)[
    - Created a machine that automatically flips pancakes
    - Used open-source computer vision libraries to control when the pancakes
        flip.
    - Added input for how brown the panacakes should be.
    - Designed and fabricated everything for the pancake flipper.
    - Collected visual data from more than 123 pancake-making sessions to feed
      the visual model.
  ],
  Project(
    title: "Automatic Pancake Maker",
    timeframe: 2043,
  )[
    - Created a machine that automatically makes pancake batter.
    - Used math#sym.trademark to control the robotic arm that picks ingredients.
    - Added a user interface that allows specifying levels of fluffiness,
        alternate ingredients such as blueberries and bananas, and an
        "experiment" mode where it just randomly makes something.
  ],
)

#let skills = Skills-section(
  Skillset(
    "Simulation",
    "Simulation Software 1",
    "Simulation Design",
    "FEA Software",
  ),
  Skillset("Software", "Office Suite", "CAD Software"),
)

#show: resume.with(author, contacts, education, work, projects, skills)
