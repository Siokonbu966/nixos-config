const TYPES = [
  "feat",
  "fix",
  "docs",
  "build",
  "chore",
  "ci",
  "refactor",
  "test",
  "perf",
  "style",
  "revert",
] as const

const HEADER = new RegExp(
  `^(${TYPES.join("|")})(?:\\(([^()\\r\\n]+)\\))?: ([^\\r\\n]+)$`,
)

/** Return a validation error, or null when the message follows our commit convention. */
export function validateCommitMessage(message: string): string | null {
  if (message.includes("\n") || message.includes("\r")) {
    return "commit message must be a single line"
  }
  if (message.trim() !== message) {
    return "commit message must not start or end with whitespace"
  }

  const match = HEADER.exec(message)
  if (!match) {
    return "use <type>[optional scope]: <description> with an allowed type"
  }

  const [, , scope, description] = match
  if (scope !== undefined && scope.trim() !== scope) {
    return "scope must not start or end with whitespace"
  }
  if (!/^[a-z]/.test(description)) {
    return "description must start with a lowercase letter"
  }
  if (description.endsWith(".")) {
    return "description must not end with a period"
  }
  if (description.trim() !== description) {
    return "description must not start or end with whitespace"
  }

  return null
}
