// src/__ tests __/App.test.tsx

import { render } from "@testing-library/react"
import App from "./App"
import { BrowserRouter } from "react-router-dom"

test('demo', () => {
    expect(true).toBe(true)
})

test("Renders the main page", () => {
    render(<BrowserRouter><App /></BrowserRouter>)
    expect(true).toBeTruthy()
})

