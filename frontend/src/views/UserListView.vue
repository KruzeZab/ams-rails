<script setup lang="ts">
const users = [
  {
    id: 1,
    firstName: 'Kaushal',
    lastName: 'Bhattarai',
    gender: 'm',
    dateOfBirth: 'April 2nd, 1999',
    phone: '145896321',
    email: 'kaushal@gmail.com',
  },
  {
    id: 2,
    firstName: 'Sita',
    lastName: 'Karki',
    gender: 'f',
    dateOfBirth: 'May 12th, 2000',
    phone: '987654321',
    email: 'sita.karki@example.com',
  },
  {
    id: 3,
    firstName: 'Ram',
    lastName: 'Sharma',
    gender: 'm',
    dateOfBirth: 'June 23rd, 1995',
    phone: '123456789',
    email: 'ram.sharma@example.com',
  },
  {
    id: 4,
    firstName: 'Gita',
    lastName: 'Adhikari',
    gender: 'f',
    dateOfBirth: 'July 14th, 1998',
    phone: '321654987',
    email: 'gita.adhikari@example.com',
  },
  {
    id: 5,
    firstName: 'Bishal',
    lastName: 'Rai',
    gender: 'm',
    dateOfBirth: 'March 9th, 1997',
    phone: '456789123',
    email: 'bishal.rai@example.com',
  },
  {
    id: 6,
    firstName: 'Sunita',
    lastName: 'Lama',
    gender: 'f',
    dateOfBirth: 'September 3rd, 1996',
    phone: '654321987',
    email: 'sunita.lama@example.com',
  },
  {
    id: 7,
    firstName: 'Niraj',
    lastName: 'Thapa',
    gender: 'm',
    dateOfBirth: 'December 30th, 1994',
    phone: '789123456',
    email: 'niraj.thapa@example.com',
  },
  {
    id: 8,
    firstName: 'Anita',
    lastName: 'Gurung',
    gender: 'f',
    dateOfBirth: 'October 25th, 2001',
    phone: '987321654',
    email: 'anita.gurung@example.com',
  },
  {
    id: 9,
    firstName: 'Prakash',
    lastName: 'Basnet',
    gender: 'm',
    dateOfBirth: 'January 15th, 1993',
    phone: '321987654',
    email: 'prakash.basnet@example.com',
  },
  {
    id: 10,
    firstName: 'Mina',
    lastName: 'Subedi',
    gender: 'f',
    dateOfBirth: 'November 8th, 1992',
    phone: '159753486',
    email: 'mina.subedi@example.com',
  },
  {
    id: 11,
    firstName: 'Dipesh',
    lastName: 'Chhetri',
    gender: 'm',
    dateOfBirth: 'August 18th, 2002',
    phone: '753159486',
    email: 'dipesh.chhetri@example.com',
  },
  {
    id: 12,
    firstName: 'Sangita',
    lastName: 'Magar',
    gender: 'f',
    dateOfBirth: 'April 28th, 1990',
    phone: '258963147',
    email: 'sangita.magar@example.com',
  },
  {
    id: 13,
    firstName: 'Raj',
    lastName: 'Shrestha',
    gender: 'm',
    dateOfBirth: 'May 6th, 1988',
    phone: '369258147',
    email: 'raj.shrestha@example.com',
  },
  {
    id: 14,
    firstName: 'Kabita',
    lastName: 'Pun',
    gender: 'f',
    dateOfBirth: 'July 11th, 1991',
    phone: '456123789',
    email: 'kabita.pun@example.com',
  },
  {
    id: 15,
    firstName: 'Binod',
    lastName: 'Khadka',
    gender: 'm',
    dateOfBirth: 'September 20th, 1989',
    phone: '789456123',
    email: 'binod.khadka@example.com',
  },
  {
    id: 16,
    firstName: 'Rekha',
    lastName: 'Ghale',
    gender: 'f',
    dateOfBirth: 'December 5th, 1995',
    phone: '147258369',
    email: 'rekha.ghale@example.com',
  },
  {
    id: 17,
    firstName: 'Suman',
    lastName: 'Tamang',
    gender: 'm',
    dateOfBirth: 'October 16th, 2000',
    phone: '963852741',
    email: 'suman.tamang@example.com',
  },
  {
    id: 18,
    firstName: 'Manju',
    lastName: 'Ale',
    gender: 'f',
    dateOfBirth: 'February 19th, 1993',
    phone: '852963741',
    email: 'manju.ale@example.com',
  },
  {
    id: 19,
    firstName: 'Pawan',
    lastName: 'Bhandari',
    gender: 'm',
    dateOfBirth: 'March 3rd, 1998',
    phone: '741852963',
    email: 'pawan.bhandari@example.com',
  },
  {
    id: 20,
    firstName: 'Sandhya',
    lastName: 'Rokaya',
    gender: 'f',
    dateOfBirth: 'June 21st, 1997',
    phone: '369741258',
    email: 'sandhya.rokaya@example.com',
  },
  {
    id: 21,
    firstName: 'Arjun',
    lastName: 'Baral',
    gender: 'm',
    dateOfBirth: 'January 27th, 1991',
    phone: '258147369',
    email: 'arjun.baral@example.com',
  },
  {
    id: 22,
    firstName: 'Karuna',
    lastName: 'Malla',
    gender: 'f',
    dateOfBirth: 'August 13th, 1994',
    phone: '123987654',
    email: 'karuna.malla@example.com',
  },
  {
    id: 23,
    firstName: 'Roshan',
    lastName: 'Joshi',
    gender: 'm',
    dateOfBirth: 'April 4th, 1987',
    phone: '456987123',
    email: 'roshan.joshi@example.com',
  },
  {
    id: 24,
    firstName: 'Laxmi',
    lastName: 'Dhakal',
    gender: 'f',
    dateOfBirth: 'May 22nd, 1985',
    phone: '321456987',
    email: 'laxmi.dhakal@example.com',
  },
  {
    id: 25,
    firstName: 'Ramesh',
    lastName: 'Nepali',
    gender: 'm',
    dateOfBirth: 'September 9th, 1990',
    phone: '654789321',
    email: 'ramesh.nepali@example.com',
  },
  {
    id: 26,
    firstName: 'Bimala',
    lastName: 'Pariyar',
    gender: 'f',
    dateOfBirth: 'July 29th, 1992',
    phone: '987654123',
    email: 'bimala.pariyar@example.com',
  },
  {
    id: 27,
    firstName: 'Hari',
    lastName: 'Poudel',
    gender: 'm',
    dateOfBirth: 'October 7th, 1996',
    phone: '852147963',
    email: 'hari.poudel@example.com',
  },
  {
    id: 28,
    firstName: 'Shanti',
    lastName: 'Bhujel',
    gender: 'f',
    dateOfBirth: 'December 12th, 1998',
    phone: '951357456',
    email: 'shanti.bhujel@example.com',
  },
  {
    id: 29,
    firstName: 'Suraj',
    lastName: 'Maharjan',
    gender: 'm',
    dateOfBirth: 'March 17th, 1993',
    phone: '753486159',
    email: 'suraj.maharjan@example.com',
  },
  {
    id: 30,
    firstName: 'Kamala',
    lastName: 'Ghimire',
    gender: 'f',
    dateOfBirth: 'April 9th, 1997',
    phone: '456321789',
    email: 'kamala.ghimire@example.com',
  },
  {
    id: 31,
    firstName: 'Dipak',
    lastName: 'Sapkota',
    gender: 'm',
    dateOfBirth: 'June 1st, 1992',
    phone: '789321456',
    email: 'dipak.sapkota@example.com',
  },
  {
    id: 32,
    firstName: 'Sarita',
    lastName: 'Bista',
    gender: 'f',
    dateOfBirth: 'August 15th, 1994',
    phone: '123456987',
    email: 'sarita.bista@example.com',
  },
];
</script>

<template>
  <div class="card">
    <DataTable
      :value="users"
      paginator
      :rows="10"
      tableStyle="min-width: 50rem"
    >
      <Column header="SN">
        <template #body="slotProps">
          {{ slotProps.index + 1 }}
        </template>
      </Column>

      <Column header="Full Name">
        <template #body="slotProps">
          {{ slotProps.data.lastName }}
        </template>
      </Column>

      <Column header="Gender">
        <template #body="slotProps">
          {{ slotProps.data.gender }}
        </template>
      </Column>

      <Column header="Date of Birth">
        <template #body="slotProps">
          {{ slotProps.data.dateOfBirth }}
        </template>
      </Column>

      <Column field="email" header="Email Address"></Column>
      <Column field="phone" header="Phone Number"></Column>
    </DataTable>
  </div>
</template>
