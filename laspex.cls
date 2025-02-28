
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{laspex}[2020/11/30]

\newif\if@swedish
\newif\if@instructions
\newif\if@book
\newif\if@inspicio % Bool for stage mananger
\newif\if@scenery
\newif\if@onepages
\newif\if@entrances
\newif\if@cropmarks

% Setting default values
\@bookfalse
\@swedishtrue
\@instructionstrue
\@inspiciotrue
\@scenerytrue
\@onepagestrue
\@entrancestrue
\@cropmarksfalse

% If option on
\DeclareOption{book}{\@booktrue\@twosidetrue\@sceneryfalse\@entrancesfalse}
\DeclareOption{swedish}{\@swedishtrue}
\DeclareOption{english}{\@swedishfalse}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Options
% Definiera option att ta bort scenhänvisningar
\DeclareOption{without-instructions}{\@instructionsfalse}
\DeclareOption{with-instructions}{\@instructionstrue}
\DeclareOption{utan-instruktioner}{\@instructionsfalse}
\DeclareOption{med-instruktioner}{\@instructionstrue}

% Definiera option att ta bort in- och utgångar samt teknikinstruktioner
\DeclareOption{utan-teknik}{\@sceneryfalse}
\DeclareOption{med-teknik}{\@scenerytrue}

\DeclareOption{med-onepages}{\@onepagestrue}
\DeclareOption{utan-onepages}{\@onepagesfalse}
\DeclareOption{with-entrances}{\@entrancestrue}
\DeclareOption{without-entrances}{\@entrancesfalse}

\DeclareOption{with-crop}{\@cropmarkstrue}

\ProcessOptions\relax
\if@book\LoadClass[10pt,twoside]{article}\else\LoadClass{article}\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Packages and global stuff
\RequirePackage[utf8]{inputenc}
\RequirePackage{needspace}      % To manage page breaking
\RequirePackage{fancyhdr}
\RequirePackage[yyyymmdd]{datetime}
\RequirePackage[normalem]{ulem}         % Provides styles for instructions
\RequirePackage[flushmargin]{footmisc}  % Flushes content in page footer etc.
\RequirePackage{environ, graphicx, afterpage, changepage}

\def\@actprint{Act}
\def\@sceneprint{Scene}
\def\@pageprint{Page}

%%% Important lengths
\newlength{\sepreplik}                  % Till repliker
\newlength{\vreplik}

\if@book\setlength{\vreplik}{29mm}\else\setlength{\vreplik}{27mm}\fi
\setlength{\sepreplik}{\vreplik}
\addtolength{\sepreplik}{-0.1in}

\newlength{\pagetextWidth}\setlength{\pagetextWidth}{133mm}
\newlength{\linetextWidth}\setlength{\linetextWidth}{133mm}\addtolength{\linetextWidth}{-\vreplik}
\newlength{\templeft}\setlength{\templeft}{18.5mm}\addtolength{\templeft}{\vreplik}

\if@book\RequirePackage[asymmetric,%
 paperheight=240mm,
 paperwidth=170mm,
 textheight=185mm,
 textwidth=\linetextWidth,
 voffset=0mm,
 hoffset=0mm,
 headsep=12pt,
 footskip=28pt,
 left=\templeft,
 top=26mm,
% bottom=2in,
% bmargin=1in,
% marginparsep=0.2in,   % Distance between character and line.
]{geometry}%
\if@cropmarks\usepackage[cam,a4,center]{crop}\fi%
\else\RequirePackage[a4paper,
 left=1.9in,
 top=1in,
 headsep=0.15in,
 bottom=2in,
 bmargin=1in,
 marginparwidth=1.1in,
 textwidth=4.65in,
 marginparsep=0.2in,            % Distance between character and line.
 footskip=30pt
]{geometry}\fi

\setlength{\parindent}{0pt}     % Removes indents in the beginning of paragraphs
\pagestyle{fancy}               % Enable headings

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Counters, counters are set to zero upon creation
\newcounter{pagecounter_help}
\newcounter{pagecounter_help2}
\newcounter{actcounter}
\newcounter{scencounter}
\setcounter{scencounter}{1}
\newcounter{subscenecounter}
\newcounter{paragraphsOnPage}[page]     % set to zero each time page is updated
\newcounter{scenesOnPage}[paragraph]    % Try also scene

%%% Lengths (should be removed and defined when used?)
\newlength{\tmpl}                       % For subscenes
\newlength{\tmpM}                       % For subtitle music
\newlength{\tmpE}                       % For eller-title

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Language selection
\if@swedish%
\def\@actprint{Akt}
\def\@sceneprint{Scen}%
\def\@pageprint{Sida}%
\RequirePackage[swedish]{babel}\fi

\newcommand{\actprint}{\expandafter\MakeUppercase\expandafter{\@actprint}}
\newcommand{\sceneprint}{\expandafter\MakeUppercase\expandafter{\@sceneprint}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Headers and footers
\if@book\else\renewcommand{\headrulewidth}{0pt}\fi% Removes header horizontal line.

\newcommand{\headertext}[1]{\bf{\footnotesize #1}}
\if@book\font\eightbf=cmbx8\renewcommand{\headertext}[1]{{\eightbf #1}}\fi

%%% Common header and footer
\fancyhf{}
\rhead{%
    \headertext{\spextitel{}}%
    \settowidth{\tmpE}{\ellertitel{}}%
    % If tmpE is empty, do nothing, otherwise, print out eller-title
    \ifnum\tmpE>0\headertext{ -- eller \ellertitel}\fi%
    \setcounter{pagecounter_help2}{\value{page}}%
    \addtocounter{pagecounter_help2}{-\value{pagecounter_help}}%
    \addtocounter{pagecounter_help2}{1}%
    \mbox{%
        \hspace{\marginparsep}\parbox[b]{20mm}%
        {\headertext{\@pageprint{} \arabic{actcounter}.\arabic{pagecounter_help2}}}}%
    \hspace{-\marginparsep}\hspace{-20mm}%
}
\lhead{\footnotesize\bf{\@actprint{} \theactcounter}}
\lfoot{\footnotesize Utskrift: \today, kl. \currenttime}

\if@book\fancyhf{}%
        \fancyheadoffset[lh]{\vreplik}%
        \fancyhead[RO]{\footnotesize\bf{\korttitel{} \theactcounter:\thescencounter}}%
        \fancyhead[LE]{\footnotesize\bf{\spextitel{}}}%
        \fancyfootoffset[lf]{\vreplik}%
        \fancyfoot{\hrulefill\raisebox{-.6ex}{\, {\bf \thepage}\, }\hrulefill}\fi

%%% First page of act
\fancypagestyle{firstPageOfAct}{
    \fancyheadoffset[lh]{\vreplik}%
    \fancyhead[RO]{\footnotesize\bf{\korttitel{} \theactcounter}}%
    \fancyhead[LE]{\footnotesize\bf{\spextitel{}}}%
}

%%% Front page header and footer
\fancypagestyle{framsida}{
    \def\SPeX{S\kern-.125em P\kern-.1667em \lower.5ex\hbox{E}\kern-.125em X}
    \def\LaSPeX{L\kern -.36em \raise.5ex\hbox{A}\kern -.15em\SPeX}
    \renewcommand{\headrulewidth}{0pt}
    \fancyhf{}
    \if@book\else%
        \lfoot{\footnotesize Utskrift: \today, kl. \currenttime}
        \rfoot{\footnotesize \parbox[b]{65mm}{Skrivet i Jespers \LaSPeX-mall,\\ klart inspirerat utav Grodans \SPeX-mall}}%
    \fi
}

%%% Character page header and footer
\fancypagestyle{karaktarsida}{%
    \fancyhf{}%
    \if@book\fancyheadoffset[lh]{0pt}\else\lfoot{\footnotesize Utskrift: \today, kl. \currenttime}%
    \rhead{\footnotesize\bf{\spextitel{}}%
        \settowidth{\tmpE}{\ellertitel{}}%
        \ifnum\tmpE>0\textrm{ -- eller }\bf{\ellertitel}\else\ignorespaces\fi%
        % Print page number
        \mbox{\hspace{\marginparsep}\parbox[b]{20mm}{\@pageprint{} \thepage}}%
        \hspace{-\marginparsep}\hspace{-20mm}%
    }\fi%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Framsidan
\NewEnviron{framsida}{%
    \clearpage%
    \pagestyle{framsida}
    \if@book%
        \begin{adjustwidth}{\dimexpr -\vreplik+1cm}{1cm}
    \else%
        \newgeometry{left=1.5in,right=1.5in}%
    \fi
    \if@book\bgroup\fi
    \centering
    \if@book%
        \font\titelfont=cmr10 scaled 2400%
        \font\undertitelfont=cmbx10 scaled 1440%
        {\titelfont\spextitel}\\ \bigskip%
        {\bf eller}\\ \bigskip%
        {\undertitelfont\ellertitel}%
        \bigskip\bigskip\bigskip%
        \par\egroup\medskip\ignorespaces%
    \else%
        {\Huge\spextitel}\\%
        \settowidth{\tmpE}{\ellertitel{}}%
        \ifnum\tmpE>0\bigskip%
            {\Large eller}\\ \medskip%
            {\huge\ellertitel}
        \else%
            \ignorespaces%
        \fi%
        \bigskip\par
    \fi%
    \BODY%
    \if@book%
        \end{adjustwidth}%
    \fi%
    \clearpage\setcounter{page}{1}%
}

%%% Karaktärsidan/rollbeskrivning
\newenvironment{karaktarsida}{
    \if@book\newgeometry{left=18.5mm,right=18.5mm}\fi%
    \pagenumbering{roman}
    \pagestyle{karaktarsida}
}
{\clearpage}                                % new page

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kommandon för repliker och scenanvisningar

% Replik
\newcommand{\replik}[1]{%
    \if@book\vspace{1mm}\else\vspace{2mm}\fi\Needspace{24pt}%
    \hspace{-\vreplik}%
    \mbox{%
        \parbox[b]{\sepreplik}{\raggedright%
            \if@book\else\bf\fi{#1:}}}%
        \hspace{7pt}\ignorespaces}%
% Fortsätt replik
\newcommand{\forts}{\if@book\vspace{1mm}\else\vspace{2mm}\fi\Needspace{24pt}\ignorespaces}
% Wide line
\newcommand{\wideLine}[1]{\if@book\vspace{1mm}\else\vspace{2mm}\fi\Needspace{24pt}%
    \hspace{-\vreplik}%
    \mbox{%
        \parbox[b]{\pagetextWidth}{\raggedright%
            \if@book\else\bf\fi{#1:}}}%
        \hspace{7pt}\vspace{1mm}\par%
        \ignorespaces}%
% Bred replik
\newcommand{\bredReplik}[1]{\wideLine{#1}}

% För att markera nya repliker
\newcommand{\nytt}[1]{#1\marginpar{\texttt{NYTT!!!}}}
% För att markera strukna repliker
\newcommand{\struket}[1]{\sout{#1}\marginpar{\normalsize{\texttt{Struket}}}}

%%% In- och utgång samt rekvisita
\newcommand{\stageInstruction}[2]{%
        \if@entrances\vspace{2mm}\Needspace{24pt}{\uwave{#1}}%
        \marginpar{\texttt{#2}}\fi\ignorespaces}
% Ingång
\newcommand{\ingang}[1]{\stageInstruction{#1}{Ingång}}
% Utgång
\newcommand{\utgang}[1]{\stageInstruction{#1}{Utgång}}
% Dekor, rekvisita och teknik
\newcommand{\dekor}[1]{%
    \if@scenery\margintext{Dekor}{#1}\else\ignorespaces\fi}
\newcommand{\rekvisita}[1]{%
    \if@scenery\margintext{Rekvisita}{#1}\else\ignorespaces\fi}
\newcommand{\teknik}[1]{%
    \if@scenery\margintext{Teknik}{#1}\else\ignorespaces\fi}

% För beskrivning i sidfot till \dekor, \rekvisita, \teknik
\newcommand{\margintext}[2]{\if@scenery%
    \marginpar{\texttt{#1}}%
    \begingroup%
        \def\footnote{\gdef\@thefnmark{}\@footnotetext}%
        \footnote{%
            \hspace{-0pt}%
            \mbox{%
                \hspace{-\vreplik}\parbox[b]{\sepreplik}%
                {\texttt{#1}}}%
            \hspace{7pt}#2%
        }%
        \addtocounter{footnote}{-1}%
    \endgroup\fi\ignorespaces%
}

%%% Instruction/comment/etc. Scenanvisningar/kommentarer
%   To hid, use without-instructions as option
%   Dessa kan gömmas med valet utan-instruktioner i manus preamble:
% Instruction/Scenanvisning
\newcommand{\instruction}[1]{%
    \if@instructions%
        \if@book\vspace{1mm}%
        \else\vspace{2mm}\fi\bgroup\small%
        \Needspace{24pt}{\textit{#1}}\egroup%
	\else\ignorespaces\fi}
\newcommand{\scenanvisning}[1]{\instruction{#1}}
% Continuation of instruction on line/Fortsätt scenanvisning på rad
\newcommand{\instructioncont}[1]{%
    \if@instructions\nopagebreak%
        {\small\textit{#1}}%
    \else\ignorespaces\fi}
\newcommand{\scenanvisningforts}[1]{\instructioncont{#1}}
% Comment/kommentar
\newcommand{\comment}[1]{%
    \if@instructions\nopagebreak$\langle${\small\textit{#1}}\nolinebreak$\rangle$%
    \else\ignorespaces\fi}
\if@book\renewcommand{\comment}[1]{%
    \if@instructions\nopagebreak{\small\textit{#1}}\else\ignorespaces\fi}\fi
\newcommand{\kommentar}[1]{\comment{#1}}
% How/hur
\newcommand{\how}[1]{\comment{#1:}}
\newcommand{\hur}[1]{\how{#1}}
% To:/Till:
\renewcommand{\to}[1]{\comment{To #1:}}
\newcommand{\till}[1]{\kommentar{Till #1:}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% music box
%\musicbox{Title}{Singer}{What happens in the song}{Original
%           title}{Original composer}{Optional subtitle}
\newlength{\MBInnerWidth}
\setlength{\MBInnerWidth}{\textwidth}
\if@book\addtolength{\MBInnerWidth}{\vreplik}%
        \addtolength{\MBInnerWidth}{-2.8pt}%
        \addtolength{\MBInnerWidth}{-2mm}%
\else\addtolength{\MBInnerWidth}{-9.6pt}\fi
\newcommand{\musicbox}[6]{
    \medskip%
    \bgroup\setlength{\fboxsep}{1pt}\fbox{%
    \bgroup\setlength{\fboxsep}{3pt}\fbox{%
    \vbox{%
        \hbox{\parbox[t]{0.8\MBInnerWidth}{\small #2}}%
        \medskip%
        \hbox{\makebox[\MBInnerWidth][c]{\Large\bf{#1}}}%
        \settowidth{\tmpM}{#6}% Test if subtitle exists
        \ifnum\tmpM>0%
            \smallskip\hbox{\makebox[\MBInnerWidth][c]{#6}}\fi
        \smallskip%
        \hbox{\makebox[\MBInnerWidth][c]{({\textit{#4/#5}})}}%
        \medskip%
        \hbox{\parbox[t]{\MBInnerWidth}%
            {\textit{\small #3}}}%
    }}\egroup}\egroup%
\medskip}
\if@book\renewcommand{\musicbox}[6]{\vspace{3mm}%
    \bgroup\setlength{\fboxrule}{0.4pt}\setlength{\fboxsep}{1mm}%
    \hspace{-\vreplik}\fbox{%
    \bgroup\setlength{\fboxrule}{1.0pt}\setlength{\fboxsep}{0pt}\fbox{%
    \vbox{%
        \vspace*{4mm}%
        \hbox{\makebox[\MBInnerWidth][c]{\Large\bf{#1}}}%
        \settowidth{\tmpM}{#6}\ifnum\tmpM>0%
            \vspace*{3pt}\hbox{\makebox[\MBInnerWidth][c]{#6}}%
        \fi%
        \vspace*{3pt}%
        \hbox{\makebox[\MBInnerWidth][c]{#2}}%
        \vspace*{4mm}%
    }}\egroup}\egroup\vspace{3mm}}%
\fi
\newcommand{\musikbox}[6]{\musicbox{#1}{#2}{#3}{#4}{#5}{#6}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scenes and acts
\newcommand{\actfont}[1]{{\Large\bf{#1}}}
\newcommand{\scenfont}[1]{{\bf{#1}}}
\if@book\font\tmpactfont=cmbx10 scaled 1440%
        \renewcommand{\actfont}[1]{{\tmpactfont#1}}\fi

% Act
\newcommand{\act}[1]{%
    \if@book\thispagestyle{firstPageOfAct}\fi
    % To make line-breaking easier
    \obeylines              % A new line starts a new paragraph. Placed here
                            % because it doesn't work outside of a command
    % Create new page if not first act
    \ifnum\value{actcounter}>0 \newpage\else\ignorespaces\fi%
    \vspace{2mm}%
    \stepcounter{actcounter}%
    \setcounter{pagecounter_help}{\value{page}}%
    \setcounter{pagecounter_help2}{1}%
    \hspace{-\vreplik}%
    \if@book\hfil\actfont{\actprint{} \arabic{actcounter}}\hfil%
    \else\parbox[b]{\sepreplik}%
        {\raggedright\actfont{\uppercase{\actprint{}} \arabic{actcounter}}}\hspace{7pt}%
    \fi%
    \settowidth{\tmpM}{#1}%
    \ifnum\tmpM>0%
        \if@book\par\medskip%
            \hspace{-\vreplik}\hfill\actfont{#1}\hfill%
        \else\actfont{#1}%
        \fi%
    \else\par\fi
    \value{scencounter} = 0% Reset scene counter
    \everypar{\hangindent1em\hangafter1}%
    \smallskip%
}
\newcommand{\akt}[1]{\act{#1}}
% Scene
\newcommand{\scene}[1]{%
    \if@book\medskip\else\enlinje\fi%
    \Needspace{72pt}%
    \stepcounter{scencounter}%
    \setcounter{subscenecounter}{0}%
    \hspace{-\vreplik}%
    \if@book{\hrulefill\raisebox{-.5ex}{\, \scenfont{\uppercase{\sceneprint{}} %
        \arabic{actcounter}:\arabic{scencounter}}\, }\hrulefill}%
        \par\smallskip\hspace{-\vreplik}\hfill\scenfont{#1}\hfill%
    %\if@book\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern5pt%
    %    \scenfont{\uppercase{\sceneprint{}} \arabic{actcounter}:\arabic{scencounter}}%
    %    \kern5pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern\z@%
    %    \par\smallskip\hspace{-\vreplik}\hfill\scenfont{#1}\hfill%
    \else\parbox[b]{\sepreplik}%
    {\raggedright\scenfont{\uppercase{\sceneprint{}} \arabic{actcounter}.\arabic{scencounter}}}\hspace{7pt}\scenfont{#1}% Scene name
    \fi%
    \if@book\vspace{0mm}\else\vspace{2mm}\fi
}
\newcommand{\scen}[1]{\scene{#1}}

% Subscene/subscen
% First, no-star version
\newcommand{\subscennostar}[2]{%
    \if@book\bigskip\else\enlinje\fi%
    \Needspace{72pt}%
    % If this is the first subscen (within
    % a scene), increase scencounter
    \ifthenelse{\value{subscenecounter} = 0}%
    {%\stepcounter{scencounter}
    }{}%
    \stepcounter{subscenecounter}%
    \hspace{-\vreplik}%
    \if@book\leavevmode\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern5pt%
        \scenfont{\large\uppercase{\sceneprint{}} \arabic{actcounter}:\arabic{scencounter}\alph{subscenecounter}}%
        \kern5pt\leaders\hbox{\rule[3pt]{0.4pt}{0.4pt}}\hfill\kern\z@%
        \par\smallskip\hspace{-\vreplik}\hfill\scenfont{\large#1}\hfill%
    \else\parbox[b]{\sepreplik}{%
        \raggedright\scenfont{%
            SCEN \arabic{actcounter}.\arabic{scencounter}%
            % Set tmpl to width of #2
            \settowidth{\tmpl}{#2}%
            % If tmpl is empty, use subscenecounter
            \ifthenelse{\lengthtest{\tmpl=0pt}}%
            % linebreak is to place linebreak if too wide.
            {\alph{subscenecounter}}{\linebreak[0]#2}%
        }%
    }\hspace{7pt}\scenfont{#1}\fi%
    \if@book\vspace{0mm}\else\vspace{2mm}\fi
}
% Starred version
\newcommand{\subscenstar}[2]{
    % If starred version, increment scenecounter and reset subscenecounter.
    \setcounter{subscenecounter}{0}%
    \stepcounter{scencounter}%
    \subscennostar{#1}{#2}%
}
% Actually called command
\newcommand\subscen{
\@ifstar\subscenstar\subscennostar}

% Definierar en linje, används av \scen och \subscen
\newcommand*{\enlinje}{
    \vspace{2mm}\cleaders\vbox to 0.4pt{\hrulefill}\vskip0.4pt\vspace{1mm}
}

% Definiera styrbord
\newcommand{\styrbord}[1]{\hfill\begin{minipage}[t]{0.7\textwidth}%
    \hspace{0pt}% Important, otherwise vertical space is added!
    \everypar{\hangindent1em \hangafter1}% Keep hang indentation
    \raggedleft#1\end{minipage}}
% Definiera babord
\newcommand{\babord}[1]{\begin{minipage}[t]{0.7\textwidth}%
    \hspace{0pt}% Important, otherwise vertical space is added!
    \everypar{\hangindent1em \hangafter1}% Keep hang indentation
    #1\end{minipage}}

% Definiera mittbord
\newcommand{\mittbord}[1]{\hspace*{\fill}\begin{minipage}[t]{0.7\textwidth}%
    \hspace{0pt}% Important, otherwise vertical space is added!
    \centering#1\end{minipage}\hspace*{\fill}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{onepage}{%
    \if@onepages%
        % Print the content on the following page, which is necessary to
        %   specify since the command ends with a \clearpage
        % Ensure the content of this float is printed at the top of the page
        \makeatletter
            \setlength{\@fptop}{0pt}
        \makeatother
        % Define a float
        \begin{figure}[p]\if@book\hspace{-\vreplik}\fi% 
            % Use a minipage to ensure the width of the float
            \begin{minipage}[t]{%
                \if@book%
                    \pagetextWidth%
                \else%
                    \textwidth\fi%
                }\BODY%
            \end{minipage}%
        \end{figure}%
        % Clear the page of more content and restore placement of floats
        \clearpage%
        \makeatletter
            \setlength{\@fptop}{0pt plus 1fil}
        \makeatother
    \else%
        \ignorespaces%
    \fi%
}

\newcommand{\centeredContent}[1]{%
    \hspace{-\vreplik}%
    \begin{minipage}[t]{\pagetextWidth}%
    \centering #1%
    \end{minipage}%
}

\newlength{\ramskip}
\newlength{\eftersongrubrik}
\setlength{\ramskip}{3mm}
\setlength{\eftersongrubrik}{0mm}

\newcommand{\sanglada}[1]{%
\noindent\framebox[\textwidth]{%
\vspace{\ramskip}%
\makebox[\textwidth][c]{%
\begin{minipage}[t]{129.5mm}%
{\setlength{\columnsep}{18mm}
 \setlength{\parskip}{12pt}%
#1%
}%
\vspace{\ramskip}%
\end{minipage}}}}

\newcommand{\radskip}{\\ \hspace*{0pt}\ignorespaces}
\newcommand{\sangare}[1]{%
\hspace*{-10mm}\makebox[10mm][l]{#1:}%
\ignorespaces}

\NewEnviron{sangtextsingel}{%
\makebox[\textwidth][c]{%
\begin{minipage}{122mm}\BODY%
\end{minipage}}}%

\NewEnviron{sangtext}{%
\makebox[\textwidth][c]{%
\hspace*{10mm}\begin{minipage}{112mm}\BODY%
\end{minipage}}}%

\newcommand{\rubrik}[1]{%
\begin{sangtextsingel}\vspace{12pt}\makebox[\textwidth][c]{%
 {\Large\bf #1}}\vspace{\eftersongrubrik}\end{sangtextsingel}}
