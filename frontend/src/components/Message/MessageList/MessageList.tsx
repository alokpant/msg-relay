import { useEffect, useState } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { buildUrlParams } from '../../../helpers/utils';
import { DataGrid, GridColDef, GridEventListener } from '@mui/x-data-grid';
import { Box, Typography } from '@mui/material';
import CreateNewMessage from '../CreateMessage/CreateMessage';
import EditMessage from '../EditMessage/EditMessage';
import { ResponseError } from '../../types';

const columns: GridColDef[] = [
  { field: 'id', headerName: 'ID', width: 80 },
  { field: 'title', headerName: 'Subject', flex: 2 },
  { field: 'body', headerName: 'Message', flex: 3 },
  {
    field: 'created_at',
    headerName: 'Created At',
    flex: 2,
  },
];

interface Message {
  id: string
  title: string
  body: string
  createdAt: string
}

const Messages = () => {
  const { userId, } = useParams();
  const [messages, setMessages] = useState<Message[]>([]);
  const [refetchMessages, setRefetchMessages] = useState<boolean>(false);
  const [editMessage, setEditMessage] = useState<boolean>(false);
  const [messageToEdit, setMessageToEdit] = useState({ id: '0', title: '', message: '' });
  const { state: { token, email } } = useLocation();

  useEffect(() => {
    const apiUrl = `http://localhost:3000/messages?${buildUrlParams({ limit: '999', user_id: userId  })}`;
    
    fetch(apiUrl, {
      headers: {
        'Authorization': token,
      },
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then((data: Message[]) => {
        setMessages(data);
        setRefetchMessages(false);
      })
      .catch((error: ResponseError) => {
        console.error('Error fetching messages:', error.message);
      });
  }, [userId, refetchMessages]);

  const handleRowClickEvent: GridEventListener<'rowClick'> = (
    params, // GridRowParams
  ) => {
    const { row: { title, body }, id } = params;
    setMessageToEdit({
      title: title,
      message: body,
      id: String(id)
    })
    setEditMessage(true)
  };

  return (
    <>
      <Box sx={{
        display: 'flex',
        justifyContent: 'space-between',
      }}>
        <Typography variant='h6' component='h1'>
          Messages for { email }
        </Typography>
        <CreateNewMessage setRefetchMessages={setRefetchMessages} token={token} />
      </Box>
      <DataGrid
        rows={messages}
        columns={columns}
        initialState={{
          pagination: {
            paginationModel: { page: 0, pageSize: 10 },
          },
        }}
        onRowClick={handleRowClickEvent}
        sx={{
          width: '100%',
          background: '#fff'
        }}
        autoHeight={true}
      />
      <EditMessage setRefetchMessages={setRefetchMessages}
        token={token}
        body={messageToEdit}
        open={editMessage}
        setOpen={setEditMessage}
      />
    </>
  );
};

export default Messages;
