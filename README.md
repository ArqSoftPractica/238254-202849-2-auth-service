# 238254-202849-2-auth-service
Microservice to manage authentication and authorization.
It is used by the users microservice to manage the authentication and authorization of the users.

## Integrantes
- Agustín Hernández
- Tadeo Artía

## Tecnologías
- [Ruby](https://www.ruby-lang.org/en/)
- [Sinatra](https://sinatrarb.com/)
- [Rspec](https://rspec.info/)
- [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html)
- [JWT](https://jwt.io/)
- [Puma](https://github.com/puma/puma)
- [Rack Cors](https://github.com/cyu/rack-cors)
- [PostgreSQL](https://www.postgresql.org/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Redis](https://redis.io/)


## Configuración de ambiente de desarrollo
### Ejecución del proyecto
1. Clonar el [repositorio](https://github.com/ArqSoftPractica/238254-202849-2-auth-service)
```
git clone git@github.com:ArqSoftPractica/238254-202849-2-auth-service.git
cd 238254-202849-2-auth-service
```
2. Instalar [Docker](https://docs.docker.com/get-docker/)
3. Instalar [Docker Compose](https://docs.docker.com/compose/install/)
4. Crear un archivo `.env` en la raíz del proyecto con el siguiendo el formato del archivo [`.env.example`](https://github.com/ArqSoftPractica/238254-202849-2-auth-service/blob/develop/.env.sample)
5. Ejecutar `docker-compose up` en la raíz del proyecto
