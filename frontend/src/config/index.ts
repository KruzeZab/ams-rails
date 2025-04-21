const config = {
  serverUrl: 'http://localhost:3000/api/v1',
  endpoints: {
    users: '/users',
    userDetail: '/users/:id',
    login: '/login',
    signup: '/register',
    createUser: '/users',
    artists: '/artists',
    artist: '/artists/:artistId',
    songs: '/musics',
    songDetail: '/musics/:songId',
    artistUpload: '/artists/upload',
    artistDownload: '/artists/download',
    checkEmail: '/users/check-email',
  },
};

export default config;
