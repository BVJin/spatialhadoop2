<%@ page
  contentType="text/html; charset=UTF-8"
  import="edu.umn.cs.spatialHadoop.operations.KNN"
  import="org.apache.hadoop.conf.Configuration"
  import="org.apache.hadoop.fs.*"
  import="org.apache.hadoop.hdfs.server.namenode.JspHelper"
  import="edu.umn.cs.spatialHadoop.core.*"
  import="org.apache.hadoop.mapred.RunningJob"
  
  
  import="java.io.*"
  import="java.net.*"
  import="java.util.*"
  import="org.apache.hadoop.mapred.*"
  import="org.apache.hadoop.util.*"
  import="org.apache.hadoop.net.*"
  import="org.apache.hadoop.fs.*"
  import="javax.servlet.jsp.*"
  import="java.text.SimpleDateFormat"
  import="org.apache.hadoop.http.HtmlQuoting"
  import="org.apache.hadoop.mapred.*"

%>

<%! private static final long serialVersionUID = 1L;%>
<%! static JspHelper jspHelper = new JspHelper(); %>

<%
  if (request.getParameter("input") == null ||
      request.getParameter("x") == null ||
      request.getParameter("y") == null ||
      request.getParameter("k") == null) {
    out.println("Missing input or query arguments");
  } else {
    Path input = new Path(request.getParameter("input"));
    double x = Double.parseDouble(request.getParameter("x"));
    double y = Double.parseDouble(request.getParameter("y"));
    int k = Integer.parseInt(request.getParameter("k"));
    Point query_point = new Point(x, y);
    Path output = new Path(request.getParameter("output"));
    
    Configuration conf =
      (Configuration) getServletContext().getAttribute(JspHelper.CURRENT_CONF);
    
    try{
      KNN.knnMapReduce(input.getFileSystem(conf), input, output,
          query_point, k, new OSMPolygon(), false, true);
      RunningJob running_job = KNN.lastRunningJob;
      
      // Create a link to the status of the running job
      String trackerAddress = conf.get("mapred.job.tracker.http.address");
      InetSocketAddress infoSocAddr = NetUtils.createSocketAddr(trackerAddress);
      String requestUrl = request.getRequestURL().toString();
      int cutoff = requestUrl.indexOf('/', requestUrl.lastIndexOf(':'));
      requestUrl = requestUrl.substring(0, cutoff);
      InetSocketAddress requestSocAddr = NetUtils.createSocketAddr(requestUrl);
      out.println("Job #"+running_job.getID()+" submitted successfully<br/>");
      out.print("<a target='_blank' href='"+
        "http://"+requestSocAddr.getHostName()+":"+infoSocAddr.getPort()+
        "/jobdetails.jsp?jobid="+running_job.getID()+"&amp;refresh=30"+
        "'>");
      out.print("Click here to track the job");
      out.println("</a>");
    } catch(Exception e) {
      out.println(e);
      for (StackTraceElement ste : e.getStackTrace()) {
        out.println(ste);
        out.println("<br/>");
      }
    }
  }
%>

Done