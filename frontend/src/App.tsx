import { Route, Routes } from 'react-router-dom'
import './App.css'
import UserList from './components/Users/UserList/UserList'
import Messages from './components/Message/MessageList/MessageList'

function App() {
  return (
    <Routes>
      <Route path='/' element={<UserList />} />
      <Route path="/messages/:userId" element={<Messages />} />
    </Routes>
  )
}

export default App
