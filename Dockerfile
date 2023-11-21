FROM jenkins/jenkins:lts

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

CMD ["jenkins.sh"]
