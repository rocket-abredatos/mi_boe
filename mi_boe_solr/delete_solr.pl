#!/usr/bin/env perl

use SendToSolr;

SendToSolr::sendToSolR('<delete><query>*:*</query></delete>');
SendToSolr::sendToSolR('<commit></commit>');