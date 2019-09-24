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

--- abstract

This document defines a mechanism under which a client can request
that an upstream recursive resolver perform DNS filtering on behalf of
a client-requested policy.  This is may be done, for example, under a
subscription model, where the client wishes not to get redirected
to domains known to host malware or malicious content.  This request
is sent as an EDNS0 option with every DNS request, or potentially
to just the first DNS request in a stream when using DNS over TLS, DNS
over DTLS or DNS over DOH for example.

--- middle

# Introduction

[DOCUMENT STATUS NOTE: about document status: this specification is
VERY INCOMPLETE and is at the stage of "discuss whether this is a good
or bad idea in general", and not at the stage of "your processing
steps are broken" or, worse "you mispelled misspelled".]

[There are other ways to implement what is described below, but I
wanted to pick a more novel idea to promote wider thinking than "use
an RBL like pointer" or "use a HTTPS header for just DOH because
that's really what triggered the filtering discussions in the first
place."]

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
Service Provider (ISP).  This document puts selection of a selective
DNS filtering service back in the hands of the user, since DNS
centralization threatens to remove client ability to do so.

This document defines a mechanism under which a client can request
that an upstream recursive resolver perform DNS filtering on behalf of
a client-requested policy.  This is may be done, for example, under a
subscription model, where the client wishes not to get redirected to
domains known to host malware or malicious content.  This request is
sent as an EDNS0 {{?EDNS0=RFC2671}} option with every DNS request, or
potentially to just the first DNS request in a stream when using DNS
over TLS, DNS over DTLS or DNS over DOH for example.

One could argue that clients could accomplish these goals by simply
using a different resolver.  However, this specifications allows
decoupling of resolvers and filtering such that a default resolver
configured in an operating system or application can still use a
system-level configured filtering mechanism that is independent of
resolution.  A selection of the best resolver to support resolution
services can become independent from the best source of malicious or
other filtering.

## Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{?RFC2119}}

# Extension Overview {#anothersection}

## Extension Packet Format

The EDNS0 option format for passing a filter list to the upstream DNS
resolver using the following format:

F>                                              1   1   1   1   1   1
F>      0   1   2   3   4   5   6   7   8   9   0   1   2   3   4   5  
F>    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
F> 0: |                            OPTION-CODE                        |
F>    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
F> 2: |                           OPTION-LENGTH                       |
F>    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
F> 4: / DNS-REFERENCE-NAME ...                                        /
F>    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+

The DNS-REFERENCE-NAME field is a normally encoded DNS NAME that
is expected to point to a publicly published DNS record from the
filtering service a client wishes to make use of.  Details of this
record are documented in {{filterrecord}}.

XXX: better text for normally encoded, and compression, etc

# Filter Record Overview {#filterrecord}

Filtering services that wish to publish a DNS domain filter list may
publish a DNS record containing a URI from which a resolver may fetch
the current filter list.  This published name MUST be of type TXT and
MUST begin with _dnsfilter but otherwise may be published at any point
in the DNS tree.  Multiple records SHOULD be considered as alternate
fetch points and recursive resolvers supporting this specification
should fetch the first one available and then continue with the steps
outlined in {{resolverprocessing}}.

Example:

F> _dnsfilter.example.com 86400 IN TXT "https://dnsfilter.example.org/"

# ISP signalling

ISPs may signal suggested filtering lists to their clients via
... DHCP?  (because one this document starting fight isn't enough)

Maybe a DNS request hosted by the dhcp configured resolver?

At the first search path ?  ha ha ... fight 3

[aka: ideas welocme here.]

# Resolver processing {#resolverprocessing}

Recursive resolvers supporting this specification should perform the
following steps upon receiving a request with a DNS-FILTER-NAME
option.

1. If the recursive resolver does not support filtering, it should
   process the DNS request as normal and return an Extended DNS Error
   (EDE) error of "filteringNotSupported" along with the response.
   Stop.

1. If the DNS-FILTER-NAME is not currently in its cached set of DNS
   filters, it should attempt to resolver the name pointed to by the
   DNS-FILTER-NAME record.  The list of returned URLs should attempted
   to be fetched, and the first successful download should be stored
   in a filter cache along with the DNS-FILTER-Name and the cache
   length returned by the URL server [XXX: what's the HTTP field; I
   forget].  If no URL can be successfully retrieved, then the
   resolver should continue to process the DNS request without
   applying a filter and return an EDE error of "filteringUnavailable".
   
1. The filter list returned by the URL must be of type text/plain, and
   must be a simple list of domain names that are to be blocked as
   requested.  Names encode in the list MUST domain names, as encoded
   in printed zone-format names including any required
   internationalization support.  The names MUST not include a leading
   or trailing dot.  For simplicity, no wild-carding is supported and
   a prefix of "*." is assumed.  Partial end-matches MUST NOT but
   considered a match.  For example, a domain
   "horrible.football.example.org" will match a filter entry of
   "football.example.com" but MUST NOT match an entry of
   "ball.example.org".  See {{examplefilters}} for an example of what
   a filter list may look like.  If the client's request matches a
   filter in the requested filter list, a response is sent to the
   client with an REFUSED RCODE and a EDE error code of "errfiltered
   (18)".
   
1. The resolver should continue normal resolution of the client's
   request.

XXX: should we add a 'stop' or 'continue' on error bit to the EDNS0 option?

## Example Filter List {#examplefilters}

An example filter list might include the following name list:

F> example.com
F> malware.example.org
F> notforchildren.subdomain.example.org
F> example
F> [need an internationalization example here]

Note that the last example matches everything under the 'example' TLD

# Security Considerations

Modification, addition or removal of the EDNS0 option by
device-in-the-middle attackers may cause unintended consequences for
clients hoping to apply (or avoid) filtering.  It is advisable that
DNS requests that make use of this option send it over an
authenticated transport such as {{DNSTLS}} or {{DOH}}.

Similarly, providers of DNS FILTERING lists SHOULD published their
DNS-FILTER-NAME within a DNSSEC signed zone.  They SHOULD offer (and
require) URLs that make use of protected transports, such as
{{?HTTPS=RFC7540}}.

# IANA Considerations

This document adds two new EDE codes to the EDE (xxx: ref) specification: 
filteringNotSupported and filteringUnavailable.

--- back

# Acknowledgments

peeps that help out will go here
