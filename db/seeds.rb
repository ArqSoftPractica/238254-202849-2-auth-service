users = [
  { email: 'admin@ort.com', password: 'Password1', name: 'Admin', role: 'ADMIN', companyId: 1 },
  { email: 'empleado@ort.com', password: 'Password1', name: 'Empleado', role: 'EMPLOYEE', companyId: 1 }
]

User.create(users)
