FROM ubuntu

RUN apt-get update
RUN apt-get install -y python python-dev python-lxml python-pip git

RUN pip install 'WTForms<=1.0.5'
RUN pip install feedparser  #Missing from setups

# Get all the data
RUN pip install -e git://github.com/veekun/pokedex.git#egg=pokedex
RUN pip install -e git://github.com/veekun/spline.git#egg=spline
RUN pip install -e git://github.com/veekun/spline-pokedex.git#egg=splinext.pokedex
RUN git clone git://github.com/veekun/veekun.git /usr/share/veekun
RUN git clone git://git.veekun.com/pokedex-media.git /usr/share/pokedex-media

RUN mkdir /var/cache/veekun /var/lib/veekun /var/log/veekun
RUN pokedex load -e sqlite:///var/lib/veekun/pokedex.sqlite
RUN pokedex reindex -e sqlite:///var/lib/veekun/pokedex.sqlite -i /var/lib/veekun/pokedex-index #Prep the db

RUN sed -i 's|\.exception$||' /usr/local/lib/python2.7/dist-packages/pylons/controllers/util.py

ADD production.ini /usr/share/veekun/production.ini

EXPOSE 80
CMD ["paster", "serve", "/usr/share/veekun/production.ini"]
