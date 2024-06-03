import { buildUrlParams } from "./utils";

describe('buildUrlParams', () => {
  test('returns an empty string if object is empty', () => {
    expect(buildUrlParams({})).toBe('');
  });

  test('correctly builds if object has single key/value', () => {
    expect(buildUrlParams({ param1: 'value1' })).toBe('param1=value1');
  })

  test('correctly builds if object has multiple key/value', () => {
    const params = {
      param1: 'value1',
      param2: 'value2'
    }
    expect(buildUrlParams(params)).toBe('param1=value1&param2=value2');
  })

  test('correctly builds if object has special characters', () => {
    const params = {
      param1: 'value1',
      param2: '&value2',
      param3: 'value3'
    }
    expect(buildUrlParams(params)).toBe('param1=value1&param2=%26value2&param3=value3');
  })

  test('correctly builds if object has multiple key/value with empty string', () => {
    const params = {
      param1: 'value1',
      param2: '',
      param3: 'value3'
    }
    expect(buildUrlParams(params)).toBe('param1=value1&param2=&param3=value3');
  })

  test('excludes params that is undefined', () => {
    const params = {
      param1: 'value1',
      param2: undefined,
      param3: 'value3'
    }
    expect(buildUrlParams(params)).toBe('param1=value1&param3=value3');
  })

  test('excludes any params that are undefined', () => {
    const params = {
      param1: 'value1',
      param2: undefined,
      param3: undefined
    }
    expect(buildUrlParams(params)).toBe('param1=value1');
  })
})
