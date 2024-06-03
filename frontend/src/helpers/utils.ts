export function buildUrlParams(params: Record<string, string | undefined>): string {
  const result = new URLSearchParams();

  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined) {
      result.append(key, value);
    }
  }

  return result.toString();
}