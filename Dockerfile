FROM google/python

# Install the distro version of lxml.
# Otherwise we'd have to install libxml-dev so pip could build it.
RUN apt-get install -y --no-install-recommends python-lxml

# The installed versions of pip and setuptools are out of sync.
# Update setuptools.
RUN pip install -U setuptools

# We need WTForms 1.x
RUN pip install 'WTForms<=1.0.5'

# GET ALL THE THINGS
RUN pip install -e git://github.com/veekun/pokedex.git#egg=pokedex
RUN pip install -e git://github.com/veekun/spline.git#egg=spline
RUN pip install -e git://github.com/veekun/spline-pokedex.git#egg=spline_pokedex
RUN git clone git://github.com/veekun/veekun.git /usr/share/veekun
RUN git clone git://git.veekun.com/pokedex-media.git /usr/share/pokedex-media

# Set up the database and lookup index
RUN mkdir /var/cache/veekun /var/lib/veekun /var/log/veekun
RUN pokedex load -e sqlite:///var/lib/veekun/pokedex.sqlite
RUN pokedex reindex -e sqlite:///var/lib/veekun/pokedex.sqlite -i /var/cache/veekun/pokedex-index

# Fix an incomptability with webob
RUN sed -i 's|\.exception$||' /usr/local/lib/python2.7/dist-packages/pylons/controllers/util.py

ADD production.ini /usr/share/veekun/production.ini

EXPOSE 80
CMD ["paster", "serve", "/usr/share/veekun/production.ini"]
