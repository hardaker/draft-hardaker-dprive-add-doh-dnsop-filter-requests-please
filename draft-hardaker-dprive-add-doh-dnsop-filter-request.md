---
title: "Client DNS Filtering Profile Request"
abbrev: DNS Filter Request
docname: draft-hardaker-dprive-add-doh-dnsop-filter-request
category: info
ipr: trust200902

stand_alone: yes
pi: [toc, sortrefs, symrefs, docmapping]

author:
  -
    ins: W. Hardaker
    name: Wes Hardaker
    org: USC/ISI
    email: ietf@hardakers.net

normative:


informative:
  HASH:
    title: "Deploying a New Hash Algorithm"
    author:
      -
        ins: S. Bellovin
        name: Steven M. Bellovin
      -
        ins: E. Rescorla
        name: Eric M. Rescorla
    date: 2006
    target: "https://www.cs.columbia.edu/~smb/papers/new-hash.pdf"
    seriesinfo: "Proceedings of NDSS '06"

  SNI:
    title: "Accepting that other SNI name types will never work"
    author:
      -
        ins: A. Langley
        name: Adam Langley
    date: 2016-03-03
    target: "https://mailarchive.ietf.org/arch/msg/tls/1t79gzNItZd71DwwoaqcQQ_4Yxc"


--- abstract

This document defines a mechanism under which a client can request
that an upstream recursive resolver perform DNS filtering on behalf of
a client-requested policy.  This is may be done, for example, under a
subscription model, where the client wishes not to get redirected
to domains known to host malware or malicious content.  This request
is sent as an EDNS0 extension with every DNS request, or potentially
to just the first DNS request in a stream when using DNS over TLS, DNS
over DTLS or DNS over DOH for example.

--- middle

# Introduction

DNS today provides a distributed name resolution database that serves
as the basis for many technologies, and is the starting point for
nearly all communication that occurs on the Internet.  Because of
this, it frequently serves as a filtering mechanism by Network
Providers who which to institute DNS filtering or data modification
technologies, for better or worse.  As DNS is pushing further into
being encrypted from client to recursive resolver by technologies such
as {{?DNSTLS=RFC7858}} and {{?DOH=RFC8484}}, clients are increasingly
using encrypted communication to DNS resolvers that may have different
filtering mechanisms, protective or otherwise, from their Internet
Service Provider.  This document puts selection of a selective DNS
filtering service back in the hands of the user, since DNS
centralization threatens to remove client ability to do so.

This document defines a mechanism under which a client can request
that an upstream recursive resolver perform DNS filtering on behalf of
a client-requested policy.  This is may be done, for example, under a
subscription model, where the client wishes not to get redirected
to domains known to host malware or malicious content.  This request
is sent as an EDNS0 extension with every DNS request, or potentially
to just the first DNS request in a stream when using DNS over TLS, DNS
over DTLS or DNS over DOH for example.

## Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{?RFC2119}}

# Request Overview {#anothersection}


## first subsection

Transport Layer Security (TLS) {{?TLS12=RFC5246}}  says:

> quoting something

see {{anothersection}}

# Security Considerations

Are important

# IANA Considerations

This document makes no request of IANA.

--- back

# Acknowledgments
{:numbered="false"}

peeps that helped go here
