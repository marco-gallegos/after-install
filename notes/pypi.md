# pypi

## example

commit-cli repo


## upload


### make a config file for store information

(~/.pipyrc)


[distutils]
index-servers =
  pypi
  pypitest
 
[pypi]
repository=https://upload.pypi.org/legacy/
username=your_username
password=your_password
 
[pypitest]
repository=https://test.pypi.org/legacy/
username=your_username
password=your_password

### add files for using it

Structure :

	
root-dir/   # nombre de directorio de trabajo aleatorio
  setup.py
  MANIFEST.in
  LICENSE.txt
  README.md
  mypackage/
    __init__.py
    foo.py
    bar.py
    baz.py

#### setup.py

from setuptools import setup
 
setup(
    name='mypackage',
    packages=['mypackage'], # Mismo nombre que en la estructura de carpetas de arriba
    version='0.1',
    license='LGPL v3', # La licencia que tenga tu paquete
    description='A random test lib',
    author='RDCH106',
    author_email='contact@rdch106.hol.es',
    url='https://github.com/RDCH106/mypackage', # Usa la URL del repositorio de GitHub
    download_url='https://github.com/RDCH106/parallel_foreach_submodule/archive/v0.1.tar.gz', # Te lo explico a continuación
    keywords='test example develop', # Palabras que definan tu paquete
    classifiers=['Programming Language :: Python',  # Clasificadores de compatibilidad con versiones de Python para tu paquete
                 'Programming Language :: Python :: 3.3',
                 'Programming Language :: Python :: 3.4',
                 'Programming Language :: Python :: 3.5',
                 'Programming Language :: Python :: 3.6',
                 'Programming Language :: Python :: 3.7'],
)

#### MANIFEST.in

include LICENSE.txt README.md


### upload 

python setup.py sdist upload -r pypitest

#### upload twine check

pip install setuptools twine

python3 setup.py sdist bdist_wheel

twine check dist/*

```shell
if [ "$2" = "--prod" ] ; then
    twine upload dist/* ;
else
    twine upload --repository-url https://test.pypi.org/legacy/ dist/*
fi
```