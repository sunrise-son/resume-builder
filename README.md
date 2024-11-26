# resume-builder
Build your resume from YAML

Inspired by https://github.com/mszep/pandoc_resume

### Instructions

```bash
git clone https://github.com/sunrise-son/resume-builder.git
cd resume-builder
make init
vim input.yaml
```

#### Local

Make everything

```bash
make
```

Make specifics

```bash
make pdf
make html
```

### Requirements

#### Debian / Ubuntu

```bash
sudo apt install pandoc wkhtmltopdf
sudo pip3 install jinja2-cli
```
